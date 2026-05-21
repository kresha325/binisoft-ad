import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/i18n/catalog_localized_content.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/widgets/localized_catalog_content_editor.dart';
import '../../../../core/widgets/localized_slugs_editor.dart';
import '../../../../core/widgets/localized_fields_editor.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_input_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/storage_url_resolver.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/utils/internal_slug.dart';
import '../../../../core/widgets/app_side_sheet.dart';
import '../../../../core/widgets/internal_slug_field.dart';
import '../../../../core/widgets/app_switch_row.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../domain/entities/product_image.dart';
import 'product_images_editor.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../domain/entities/attribute_definition.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_variant.dart';
import '../../domain/product_attribute_helpers.dart';
import '../providers/attributes_providers.dart';
import '../providers/products_providers.dart';
import 'attribute_field_builder.dart';
import 'product_variants_editor.dart';
import '../../../offers/presentation/widgets/product_offer_section.dart';

Future<void> showAddProductSheet(
  BuildContext context,
  WidgetRef ref, {
  required List<Category> categories,
}) async {
  final quota = ref.read(productQuotaProvider);
  final l10n = context.l10n;
  if (!quota.canCreateMore) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.productLimitReached(quota.label)),
          backgroundColor: Colors.red,
        ),
      );
    }
    return;
  }
  await showProductSheet(context, ref, categories: categories);
}

Future<void> showProductSheet(
  BuildContext context,
  WidgetRef ref, {
  required List<Category> categories,
  Product? product,
}) async {
  // Parent [WidgetRef] may be disposed while the side sheet is open; use [container].
  final providers = ProviderScope.containerOf(context, listen: false);
  final isEdit = product != null;
  final l10n = context.l10n;
  final localesConfig = providers.read(businessLocalesProvider);
  List<ProductVariant> initialVariants = [];
  final businessIdForLoad = providers.read(currentBusinessIdProvider);
  if (isEdit && businessIdForLoad != null) {
    initialVariants = await providers.read(variantRepositoryProvider).listByProduct(
          businessId: businessIdForLoad,
          productId: product.id,
        );
  }
  List<VariantDraft> variantDrafts =
      initialVariants.map(VariantDraft.fromEntity).toList();
  var content = CatalogLocalizedContent.initial(
    defaultLocale: localesConfig.defaultLocale,
    enabledLocales: localesConfig.enabledLocales,
    nameI18n: product?.nameI18n,
    descriptionI18n: product?.descriptionI18n,
    seoTitleI18n: product?.seoTitleI18n,
    seoDescriptionI18n: product?.seoDescriptionI18n,
    primaryName: product?.name,
    primaryDescription: product?.description,
    primarySeoTitle: product?.seoTitle,
    primarySeoDescription: product?.seoDescription,
  );
  final slugController = TextEditingController(text: product?.slug ?? '');
  var slugManual = isEdit;
  var localizedSlugs = Map<String, String>.from(product?.localizedSlugs ?? {});
  final priceController = TextEditingController(
    text: product?.basePrice?.toString() ?? '0',
  );
  var productImages = List<ProductImage>.from(product?.images ?? []);
  var pendingImageFiles = <PlatformFile>[];
  String? categoryId =
      product?.categoryIds.isNotEmpty == true ? product!.categoryIds.first : null;
  var active = product?.status == ProductStatus.active || product == null;
  final attributeValues = Map<String, dynamic>.from(product?.attributeData ?? {});

  final ok = await showAppSideSheet<bool>(
    context: context,
    title: isEdit ? l10n.editProduct : l10n.addProduct,
    saveLabel: isEdit ? l10n.saveChanges : l10n.saveProduct,
    child: Consumer(
      builder: (context, ref, _) {
        final attributesAsync = ref.watch(attributesListProvider);
        final locales = ref.watch(businessLocalesProvider);
        final businessId = ref.watch(currentBusinessIdProvider);

        return attributesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              context.l10n.couldNotLoadCustomFields('$e'),
              style: GoogleFonts.inter(color: Colors.red, fontSize: 14),
            ),
          ),
          data: (allAttributes) {
            final attributes = allAttributes.where((a) => a.active).toList();
            final selectAttributes = attributes
                .where((a) => a.type == AttributeType.select && a.options.length >= 2)
                .toList();
            final productSlug = normalizeInternalSlug(slugController.text.trim());
            final basePrice = double.tryParse(priceController.text.trim()) ?? 0;

            void maybeSuggestSlug() {
              if (isEdit || slugManual) return;
              final name = content.name[locales.defaultLocale]?.trim() ?? '';
              if (name.isEmpty) return;
              slugController.text = normalizeInternalSlug(name);
            }

            if (businessId == null) {
              return const SizedBox.shrink();
            }

            return StatefulBuilder(
              builder: (context, setState) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.coreDetails,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InternalSlugField(
                    controller: slugController,
                    readOnly: isEdit,
                    onManualEdit: () => slugManual = true,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 8),
                  LocalizedSlugsEditor(
                    internalSlug: productSlug,
                    defaultLocale: locales.defaultLocale,
                    enabledLocales: locales.enabledLocales,
                    values: localizedSlugs,
                    onChanged: (v) => setState(() => localizedSlugs = v),
                  ),
                  const SizedBox(height: 16),
                  LocalizedCatalogContentEditor(
                    businessId: businessId,
                    defaultLocale: locales.defaultLocale,
                    enabledLocales: locales.enabledLocales,
                    content: content,
                    onChanged: (next) => setState(() {
                      content = next;
                      maybeSuggestSlug();
                    }),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: context.l10n.productPriceLabel,
                    controller: priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Text(context.l10n.productCategoryLabel, style: AppTextStyles.fieldLabel(context)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    initialValue: categoryId,
                    dropdownColor: context.appColors.surface,
                    style: AppInputStyles.fieldText(context),
                    decoration: AppInputStyles.dropdownDecoration(
                      context,
                      hintText: context.l10n.selectOption,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(context.l10n.selectOption, style: AppInputStyles.fieldText(context)),
                      ),
                      for (final c in categories)
                        DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name, style: AppInputStyles.fieldText(context)),
                        ),
                    ],
                    onChanged: (v) => setState(() => categoryId = v),
                  ),
                  const SizedBox(height: 20),
                  ProductImagesEditor(
                    initialImages: productImages,
                    onChanged: (list) => productImages = list,
                    onPendingFilesChanged: (files) => pendingImageFiles = files,
                  ),
                  const SizedBox(height: 16),
                  AppSwitchRow(
                    label: context.l10n.productActiveLabel,
                    value: active,
                    onChanged: (v) => setState(() => active = v),
                  ),
                  if (isEdit) ...[
                    const SizedBox(height: 24),
                    ProductOfferSection(product: product),
                  ],
                  if (selectAttributes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    ProductVariantsEditor(
                      key: ValueKey('variants-$productSlug-${variantDrafts.length}'),
                      selectAttributes: selectAttributes,
                      productSlug: productSlug.isNotEmpty ? productSlug : 'product',
                      basePrice: basePrice,
                      initialVariants: initialVariants,
                      onChanged: (drafts) => variantDrafts = drafts,
                    ),
                  ],
                  if (attributes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      context.l10n.customFieldsSection,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.appColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final attr in attributes) ...[
                      AttributeFieldBuilder(
                        key: ValueKey(attr.id),
                        definition: attr,
                        value: attributeValues[attr.key],
                        onChanged: (v) {
                          attributeValues[attr.key] = v;
                          switch (attr.type) {
                            case AttributeType.text:
                            case AttributeType.textarea:
                            case AttributeType.number:
                            case AttributeType.color:
                              setState(() {});
                              break;
                            default:
                              setState(() {});
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ],
              ),
            );
          },
        );
      },
    ),
    onSave: () async {
      final locales = providers.read(businessLocalesProvider);
      final nameError = validateLocalizedRequired(
        values: content.name,
        defaultLocale: locales.defaultLocale,
        fieldLabel: 'Name',
      );
      if (nameError != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(nameError), backgroundColor: Colors.red),
          );
        }
        return false;
      }

      final businessId = providers.read(currentBusinessIdProvider);
      if (businessId == null) return false;

      final slugError = validateInternalSlugField(slugController.text.trim());
      if (slugError != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(slugError), backgroundColor: Colors.red),
          );
        }
        return false;
      }

      final internalSlug = normalizeInternalSlug(slugController.text.trim());
      final productRepo = providers.read(productRepositoryProvider);
      final slugTaken = await productRepo.isSlugTaken(
        businessId: businessId,
        slug: internalSlug,
        excludeProductId: product?.id,
      );
      if (slugTaken) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.internalSlugTaken),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }

      final attributes = (providers.read(attributesListProvider).valueOrNull ?? [])
          .where((a) => a.active)
          .toList();

      final validationError =
          validateRequiredAttributes(attributes, attributeValues);
      if (validationError != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(validationError), backgroundColor: Colors.red),
          );
        }
        return false;
      }

      try {
        final price = double.tryParse(priceController.text.trim()) ?? 0;
        final status = active ? ProductStatus.active : ProductStatus.draft;
        final categoryIds = categoryId != null ? [categoryId!] : <String>[];
        final packed = content.packForSave(
          defaultLocale: locales.defaultLocale,
          enabledLocales: locales.enabledLocales,
        );
        final name = packed.name.primary;
        final description =
            packed.description.primary.isEmpty ? null : packed.description.primary;
        final seoTitle =
            packed.seoTitle.primary.isEmpty ? null : packed.seoTitle.primary;
        final seoDescription = packed.seoDescription.primary.isEmpty
            ? null
            : packed.seoDescription.primary;
        final attributeData = serializeAttributeData(attributes, attributeValues);
        final totalVariantQty =
            variantDrafts.fold<int>(0, (sum, d) => sum + d.quantity);

        final editing = product;
        if (isEdit && editing != null) {
          final images = await _resolveProductImages(
            providers: providers,
            businessId: businessId,
            productId: editing.id,
            images: productImages,
            pendingFiles: pendingImageFiles,
            invalidUrlMessage: context.l10n.productImageInvalidUrl,
          );

          await providers.read(productRepositoryProvider).update(
                businessId: businessId,
                product: Product(
                  id: editing.id,
                  businessId: businessId,
                  name: name,
                  slug: editing.slug,
                  status: status,
                  createdAt: editing.createdAt,
                  updatedAt: DateTime.now(),
                  description: description,
                  seoTitle: seoTitle,
                  seoDescription: seoDescription,
                  categoryIds: categoryIds,
                  images: images,
                  basePrice: price,
                  baseQuantity:
                      variantDrafts.isEmpty ? editing.baseQuantity : totalVariantQty,
                  attributeData: attributeData,
                  nameI18n: packed.name.i18n,
                  descriptionI18n: packed.description.i18n,
                  seoTitleI18n: packed.seoTitle.i18n,
                  seoDescriptionI18n: packed.seoDescription.i18n,
                  localizedSlugs: localizedSlugs,
                ),
              );

          await providers.read(variantRepositoryProvider).replaceAllForProduct(
                businessId: businessId,
                productId: editing.id,
                variants: variantDrafts
                    .map(
                      (d) => d.toEntity(
                        productId: editing.id,
                        businessId: businessId,
                      ),
                    )
                    .toList(),
              );
        } else {
          final user = providers.read(authStateProvider).valueOrNull;
          final created = await productRepo.create(
                businessId: businessId,
                maxProducts: user?.maxProducts,
                name: name,
                slug: internalSlug,
                description: description,
                seoTitle: seoTitle,
                seoDescription: seoDescription,
                status: status,
                categoryIds: categoryIds,
                basePrice: price,
                attributeData: attributeData,
                nameI18n: packed.name.i18n,
                descriptionI18n: packed.description.i18n,
                seoTitleI18n: packed.seoTitle.i18n,
                seoDescriptionI18n: packed.seoDescription.i18n,
                localizedSlugs: localizedSlugs,
              );

          final images = await _resolveProductImages(
            providers: providers,
            businessId: businessId,
            productId: created.id,
            images: productImages,
            pendingFiles: pendingImageFiles,
            invalidUrlMessage: context.l10n.productImageInvalidUrl,
          );

          await providers.read(productRepositoryProvider).update(
                businessId: businessId,
                product: Product(
                  id: created.id,
                  businessId: businessId,
                  name: name,
                  slug: internalSlug,
                  status: status,
                  createdAt: created.createdAt,
                  updatedAt: DateTime.now(),
                  description: description,
                  seoTitle: seoTitle,
                  seoDescription: seoDescription,
                  categoryIds: categoryIds,
                  images: images,
                  basePrice: price,
                  baseQuantity:
                      variantDrafts.isEmpty ? created.baseQuantity : totalVariantQty,
                  attributeData: attributeData,
                  nameI18n: packed.name.i18n,
                  descriptionI18n: packed.description.i18n,
                  seoTitleI18n: packed.seoTitle.i18n,
                  seoDescriptionI18n: packed.seoDescription.i18n,
                  localizedSlugs: localizedSlugs,
                ),
              );

          await providers.read(variantRepositoryProvider).replaceAllForProduct(
                businessId: businessId,
                productId: created.id,
                variants: variantDrafts
                    .map(
                      (d) => d.toEntity(
                        productId: created.id,
                        businessId: businessId,
                      ),
                    )
                    .toList(),
              );
        }

        return true;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authErrorMessage(e)), backgroundColor: Colors.red),
          );
        }
        return false;
      }
    },
  );

  slugController.dispose();
  priceController.dispose();

  if (ok == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEdit ? l10n.productUpdated : l10n.productSaved)),
    );
  }
}

Future<List<ProductImage>> _resolveProductImages({
  required ProviderContainer providers,
  required String businessId,
  required String productId,
  required List<ProductImage> images,
  required List<PlatformFile> pendingFiles,
  required String invalidUrlMessage,
}) async {
  final upload = providers.read(mediaUploadServiceProvider);
  final resolved = <ProductImage>[];

  for (final img in images) {
    var url = img.url.trim();
    if (url.isEmpty) continue;
    if (!url.startsWith('http')) {
      url = await upload.resolveImageUrl(url);
    }
    if (StorageUrlResolver.isFirebaseStorageUrl(url) &&
        !StorageUrlResolver.hasDownloadToken(url)) {
      throw StateError(invalidUrlMessage);
    }
    resolved.add(img.copyWith(url: url));
    if (resolved.length >= kMaxProductImages) break;
  }

  for (final file in pendingFiles) {
    if (resolved.length >= kMaxProductImages) break;
    final downloadUrl = await upload.uploadProductImage(
      businessId: businessId,
      productId: productId,
      file: file,
    );
    resolved.add(ProductImage(url: downloadUrl, active: true));
  }

  return resolved;
}

Future<void> deleteProduct(
  BuildContext context,
  WidgetRef ref,
  Product product,
) async {
  final l10n = context.l10n;
  final confirmed = await showConfirmDeleteDialog(
    context,
    title: l10n.deleteProductTitle,
    message: l10n.deleteProductMessage(product.name),
  );
  if (!confirmed || !context.mounted) return;

  final providers = ProviderScope.containerOf(context, listen: false);
  final businessId = providers.read(currentBusinessIdProvider);
  if (businessId == null) return;

  try {
    await providers.read(variantRepositoryProvider).deleteAllForProduct(
          businessId: businessId,
          productId: product.id,
        );
    await providers.read(productRepositoryProvider).delete(
          businessId: businessId,
          productId: product.id,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.productDeleted)),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authErrorMessage(e)), backgroundColor: Colors.red),
      );
    }
  }
}
