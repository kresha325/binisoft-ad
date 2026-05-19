import '../../../core/i18n/app_locales.dart';
import '../../../core/i18n/localized_text.dart';
import '../../business/domain/entities/business.dart';
import '../../categories/domain/entities/category.dart';
import '../../services/domain/entities/business_service.dart';
import '../../products/domain/entities/attribute_definition.dart';
import '../../products/domain/entities/product.dart';
import '../../products/domain/product_display_fields.dart';

Map<String, dynamic> _apiMeta({
  required String locale,
  required Business? business,
}) {
  final defaultLocale = business?.defaultLocale ?? AppLocales.defaultLocale;
  final locales = business?.locales ?? AppLocales.all;
  return {
    'locale': locale,
    'defaultLocale': defaultLocale,
    'locales': locales,
    'requestedLocale': locale,
  };
}

String _resolveName({
  required String locale,
  required String defaultLocale,
  required String name,
  Map<String, String>? i18n,
}) {
  return LocalizedText.resolve(
    primary: name,
    i18n: i18n,
    locale: locale,
    defaultLocale: defaultLocale,
  );
}

/// JSON shape returned by GET /api/public/{slug}/products?lang=
Map<String, dynamic> buildPublicProductsPayload({
  required Business? business,
  required String slug,
  required List<Category> categories,
  required List<AttributeDefinition> attributes,
  required List<Product> products,
  String? locale,
}) {
  final defaultLocale = business?.defaultLocale ?? AppLocales.defaultLocale;
  final enabled = business?.locales ?? AppLocales.all;
  final resolvedLocale = AppLocales.normalize(locale) ?? defaultLocale;
  final lang = enabled.contains(resolvedLocale) ? resolvedLocale : defaultLocale;

  final categoryById = {for (final c in categories) c.id: c};

  return {
    'meta': _apiMeta(locale: lang, business: business),
    'business': {
      'name': _resolveName(
        locale: lang,
        defaultLocale: defaultLocale,
        name: business?.name ?? '',
        i18n: business?.nameI18n,
      ),
      'slug': slug,
      'description': _resolveName(
        locale: lang,
        defaultLocale: defaultLocale,
        name: business?.description ?? '',
        i18n: business?.descriptionI18n,
      ),
      'logoUrl': business?.logoUrl,
    },
    'customFields': attributes
        .where((a) => a.active)
        .map(
          (a) => {
            'id': a.id,
            'name': _resolveName(
              locale: lang,
              defaultLocale: defaultLocale,
              name: a.name,
              i18n: a.nameI18n,
            ),
            'key': a.key,
            'type': a.type.name,
            'required': a.required,
            'options': a.options,
          },
        )
        .toList(),
    'categories': categories
        .map(
          (c) => {
            'id': c.id,
            'name': _resolveName(
              locale: lang,
              defaultLocale: defaultLocale,
              name: c.name,
              i18n: c.nameI18n,
            ),
            'slug': c.slug,
            'description': _resolveName(
              locale: lang,
              defaultLocale: defaultLocale,
              name: c.description ?? '',
              i18n: c.descriptionI18n,
            ),
          },
        )
        .toList(),
    'products': products
        .where((p) => p.status == ProductStatus.active)
        .map((p) => serializePublicProduct(
              p,
              categoryById,
              attributes,
              locale: lang,
              defaultLocale: defaultLocale,
            ))
        .toList(),
  };
}

Map<String, dynamic> serializePublicProduct(
  Product product,
  Map<String, Category> categoryById,
  List<AttributeDefinition> attributes, {
  required String locale,
  required String defaultLocale,
}) {
  final categoryNames = {
    for (final id in product.categoryIds)
      id: _resolveName(
        locale: locale,
        defaultLocale: defaultLocale,
        name: categoryById[id]?.name ?? id,
        i18n: categoryById[id]?.nameI18n,
      ),
  };

  final attributesFormatted = <String, dynamic>{};
  for (final attr in attributes.where((a) => a.active)) {
    if (product.attributeData.containsKey(attr.key)) {
      attributesFormatted[attr.key] = {
        'label': _resolveName(
          locale: locale,
          defaultLocale: defaultLocale,
          name: attr.name,
          i18n: attr.nameI18n,
        ),
        'type': attr.type.name,
        'value': product.attributeData[attr.key],
        'display': formatAttributeValue(
          product.attributeData[attr.key],
          attr.type,
        ),
      };
    }
  }
  for (final entry in product.attributeData.entries) {
    if (attributesFormatted.containsKey(entry.key)) continue;
    attributesFormatted[entry.key] = {
      'label': entry.key,
      'type': 'text',
      'value': entry.value,
      'display': formatAttributeValue(entry.value),
    };
  }

  return {
    'id': product.id,
    'name': _resolveName(
      locale: locale,
      defaultLocale: defaultLocale,
      name: product.name,
      i18n: product.nameI18n,
    ),
    'slug': product.slug,
    'description': _resolveName(
      locale: locale,
      defaultLocale: defaultLocale,
      name: product.description ?? '',
      i18n: product.descriptionI18n,
    ),
    'price': product.basePrice,
    'quantity': product.baseQuantity,
    'status': product.status.name,
    'imageUrls': product.imageUrls,
    'categoryIds': product.categoryIds,
    'categories': product.categoryIds.map((id) => categoryNames[id] ?? id).toList(),
    'attributeData': product.attributeData,
    'attributes': attributesFormatted,
  };
}

Map<String, dynamic> buildPublicServicesPayload({
  required Business? business,
  required String slug,
  required List<BusinessService> services,
  String? locale,
}) {
  final defaultLocale = business?.defaultLocale ?? AppLocales.defaultLocale;
  final enabled = business?.locales ?? AppLocales.all;
  final resolvedLocale = AppLocales.normalize(locale) ?? defaultLocale;
  final lang = enabled.contains(resolvedLocale) ? resolvedLocale : defaultLocale;

  final active = services.where((s) => s.active).toList()
    ..sort((a, b) => a.order.compareTo(b.order));

  return {
    'meta': _apiMeta(locale: lang, business: business),
    'business': {
      'name': _resolveName(
        locale: lang,
        defaultLocale: defaultLocale,
        name: business?.name ?? '',
        i18n: business?.nameI18n,
      ),
      'slug': slug,
      'description': _resolveName(
        locale: lang,
        defaultLocale: defaultLocale,
        name: business?.description ?? '',
        i18n: business?.descriptionI18n,
      ),
      'logoUrl': business?.logoUrl,
    },
    'services': active
        .map(
          (s) => {
            'id': s.id,
            'name': _resolveName(
              locale: lang,
              defaultLocale: defaultLocale,
              name: s.name,
              i18n: s.nameI18n,
            ),
            'slug': s.slug,
            'description': _resolveName(
              locale: lang,
              defaultLocale: defaultLocale,
              name: s.description ?? '',
              i18n: s.descriptionI18n,
            ),
            'durationMinutes': s.durationMinutes,
            'priceEur': s.priceEur,
            'active': s.active,
            'order': s.order,
          },
        )
        .toList(),
    'serviceCount': active.length,
  };
}

Map<String, dynamic> buildPublicCategoriesPayload({
  required Business? business,
  required String slug,
  required List<Category> categories,
  String? locale,
}) {
  final defaultLocale = business?.defaultLocale ?? AppLocales.defaultLocale;
  final enabled = business?.locales ?? AppLocales.all;
  final resolvedLocale = AppLocales.normalize(locale) ?? defaultLocale;
  final lang = enabled.contains(resolvedLocale) ? resolvedLocale : defaultLocale;

  return {
    'meta': _apiMeta(locale: lang, business: business),
    'business': {
      'name': _resolveName(
        locale: lang,
        defaultLocale: defaultLocale,
        name: business?.name ?? '',
        i18n: business?.nameI18n,
      ),
      'slug': slug,
      'description': _resolveName(
        locale: lang,
        defaultLocale: defaultLocale,
        name: business?.description ?? '',
        i18n: business?.descriptionI18n,
      ),
      'logoUrl': business?.logoUrl,
    },
    'categories': categories
        .map(
          (c) => {
            'id': c.id,
            'name': _resolveName(
              locale: lang,
              defaultLocale: defaultLocale,
              name: c.name,
              i18n: c.nameI18n,
            ),
            'slug': c.slug,
            'description': _resolveName(
              locale: lang,
              defaultLocale: defaultLocale,
              name: c.description ?? '',
              i18n: c.descriptionI18n,
            ),
          },
        )
        .toList(),
  };
}
