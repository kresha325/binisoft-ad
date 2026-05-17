import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/i18n/localized_text.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/widgets/localized_fields_editor.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_input_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/storage_url_resolver.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/utils/slug.dart';
import '../../../../core/widgets/app_side_sheet.dart';
import '../../../../core/widgets/app_switch_row.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/image_url_upload_row.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../domain/entities/attribute_definition.dart';
import '../../domain/entities/product.dart';
import '../../domain/product_attribute_helpers.dart';
import '../providers/attributes_providers.dart';
import '../providers/products_providers.dart';
import 'attribute_field_builder.dart';

Future<void> showAddProductSheet(
  BuildContext context,
  WidgetRef ref, {
  required List<Category> categories,
}) async {
  final quota = ref.read(productQuotaProvider);
  if (!quota.canCreateMore) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Product limit reached (${quota.label}). Upgrade your plan in Settings.',
          ),
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
  final isEdit = product != null;
  final localesConfig = ref.read(businessLocalesProvider);
  var nameValues = LocalizedText.initialValues(
    defaultLocale: localesConfig.defaultLocale,
    enabledLocales: localesConfig.enabledLocales,
    i18n: product?.nameI18n,
    primary: product?.name,
  );
  var descValues = LocalizedText.initialValues(
    defaultLocale: localesConfig.defaultLocale,
    enabledLocales: localesConfig.enabledLocales,
    i18n: product?.descriptionI18n,
    primary: product?.description,
  );
  final priceController = TextEditingController(
    text: product?.basePrice?.toString() ?? '0',
  );
  final imageUrlController = TextEditingController(
    text: product?.imageUrls.isNotEmpty == true ? product!.imageUrls.first : '',
  );
  String? categoryId =
      product?.categoryIds.isNotEmpty == true ? product!.categoryIds.first : null;
  var active = product?.status == ProductStatus.active || product == null;
  PlatformFile? pickedFile;
  final attributeValues = Map<String, dynamic>.from(product?.attributeData ?? {});

  final ok = await showAppSideSheet<bool>(
    context: context,
    title: isEdit ? 'Edit Product' : 'Add Product',
    saveLabel: isEdit ? 'Save Changes' : 'Save Product',
    child: Consumer(
      builder: (context, ref, _) {
        final attributesAsync = ref.watch(attributesListProvider);
        final locales = ref.watch(businessLocalesProvider);

        return attributesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Could not load custom fields: $e',
              style: GoogleFonts.inter(color: Colors.red, fontSize: 14),
            ),
          ),
          data: (allAttributes) {
            final attributes = allAttributes.where((a) => a.active).toList();

            return StatefulBuilder(
              builder: (context, setState) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Core Details',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LocalizedFieldsEditor(
                    label: 'Name *',
                    enabledLocales: locales.enabledLocales,
                    values: nameValues,
                    onChanged: (v) => setState(() => nameValues = v),
                  ),
                  LocalizedFieldsEditor(
                    label: 'Description',
                    enabledLocales: locales.enabledLocales,
                    values: descValues,
                    multiline: true,
                    onChanged: (v) => setState(() => descValues = v),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Price',
                    controller: priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 16),
                  Text('Category', style: AppTextStyles.fieldLabel(context)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    initialValue: categoryId,
                    dropdownColor: context.appColors.surface,
                    style: AppInputStyles.fieldText(context),
                    decoration: AppInputStyles.dropdownDecoration(
                      context,
                      hintText: 'Select',
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text('Select', style: AppInputStyles.fieldText(context)),
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
                  ImageUrlUploadRow(
                    urlController: imageUrlController,
                    onFilePicked: (f) => setState(() => pickedFile = f),
                    fileName: pickedFile?.name,
                  ),
                  const SizedBox(height: 16),
                  AppSwitchRow(
                    label: 'Active',
                    value: active,
                    onChanged: (v) => setState(() => active = v),
                  ),
                  if (attributes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Custom Fields',
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
      final locales = ref.read(businessLocalesProvider);
      final nameError = validateLocalizedRequired(
        values: nameValues,
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

      final businessId = ref.read(currentBusinessIdProvider);
      if (businessId == null) return false;

      final attributes = (ref.read(attributesListProvider).valueOrNull ?? [])
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
        final packedName = LocalizedText.packForSave(
          defaultLocale: locales.defaultLocale,
          enabledLocales: locales.enabledLocales,
          values: nameValues,
        );
        final packedDesc = LocalizedText.packForSave(
          defaultLocale: locales.defaultLocale,
          enabledLocales: locales.enabledLocales,
          values: descValues,
        );
        final name = packedName.primary;
        final description =
            packedDesc.primary.isEmpty ? null : packedDesc.primary;
        final attributeData = serializeAttributeData(attributes, attributeValues);

        final editing = product;
        if (isEdit && editing != null) {
          final imageUrls = await _resolveImageUrls(
            ref: ref,
            businessId: businessId,
            productId: editing.id,
            existing: List<String>.from(editing.imageUrls),
            urlField: imageUrlController.text.trim(),
            pickedFile: pickedFile,
          );

          await ref.read(productRepositoryProvider).update(
                businessId: businessId,
                product: Product(
                  id: editing.id,
                  businessId: businessId,
                  name: name,
                  slug: slugify(name),
                  status: status,
                  createdAt: editing.createdAt,
                  updatedAt: DateTime.now(),
                  description: description,
                  categoryIds: categoryIds,
                  imageUrls: imageUrls,
                  basePrice: price,
                  baseQuantity: editing.baseQuantity,
                  attributeData: attributeData,
                  nameI18n: packedName.i18n,
                  descriptionI18n: packedDesc.i18n,
                ),
              );
        } else {
          final user = ref.read(authStateProvider).valueOrNull;
          final created = await ref.read(productRepositoryProvider).create(
                businessId: businessId,
                maxProducts: user?.maxProducts,
                name: name,
                description: description,
                status: status,
                categoryIds: categoryIds,
                basePrice: price,
                attributeData: attributeData,
                nameI18n: packedName.i18n,
                descriptionI18n: packedDesc.i18n,
              );

          final imageUrls = await _resolveImageUrls(
            ref: ref,
            businessId: businessId,
            productId: created.id,
            existing: const [],
            urlField: imageUrlController.text.trim(),
            pickedFile: pickedFile,
          );

          await ref.read(productRepositoryProvider).update(
                businessId: businessId,
                product: Product(
                  id: created.id,
                  businessId: businessId,
                  name: name,
                  slug: slugify(name),
                  status: status,
                  createdAt: created.createdAt,
                  updatedAt: DateTime.now(),
                  description: description,
                  categoryIds: categoryIds,
                  imageUrls: imageUrls,
                  basePrice: price,
                  baseQuantity: created.baseQuantity,
                  attributeData: attributeData,
                  nameI18n: packedName.i18n,
                  descriptionI18n: packedDesc.i18n,
                ),
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

  priceController.dispose();
  imageUrlController.dispose();

  if (ok == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEdit ? 'Product updated' : 'Product saved')),
    );
  }
}

Future<List<String>> _resolveImageUrls({
  required WidgetRef ref,
  required String businessId,
  required String productId,
  required List<String> existing,
  required String urlField,
  required PlatformFile? pickedFile,
}) async {
  if (pickedFile != null) {
    final downloadUrl = await ref.read(mediaUploadServiceProvider).uploadProductImage(
          businessId: businessId,
          productId: productId,
          file: pickedFile,
        );
    return [downloadUrl];
  }
  if (urlField.isNotEmpty) {
    final resolved = await ref.read(mediaUploadServiceProvider).resolveImageUrl(urlField);
    if (StorageUrlResolver.isFirebaseStorageUrl(resolved) &&
        !StorageUrlResolver.hasDownloadToken(resolved)) {
      throw StateError('Invalid image URL. Upload the file again or use a public https URL.');
    }
    return [resolved];
  }
  return existing;
}

Future<void> deleteProduct(
  BuildContext context,
  WidgetRef ref,
  Product product,
) async {
  final confirmed = await showConfirmDeleteDialog(
    context,
    title: 'Delete product',
    message: 'Delete "${product.name}"? This cannot be undone.',
  );
  if (!confirmed || !context.mounted) return;

  final businessId = ref.read(currentBusinessIdProvider);
  if (businessId == null) return;

  try {
    await ref.read(productRepositoryProvider).delete(
          businessId: businessId,
          productId: product.id,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted')),
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
