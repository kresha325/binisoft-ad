import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/i18n/localized_text.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/widgets/app_side_sheet.dart';
import '../../../../core/widgets/app_switch_row.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/localized_fields_editor.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/presentation/providers/business_locales_provider.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../../domain/entities/offer.dart';

class _ProductDiscountDraft {
  _ProductDiscountDraft({
    required this.product,
    this.mode = OfferDiscountMode.percent,
    this.percent = 10,
    this.salePrice,
  });

  final Product product;
  OfferDiscountMode mode;
  double percent;
  double? salePrice;
}

Future<void> showAddOfferSheet(BuildContext context, WidgetRef ref) =>
    showOfferSheet(context, ref);

Future<void> showOfferSheet(
  BuildContext context,
  WidgetRef ref, {
  Offer? offer,
}) async {
  final l10n = context.l10n;
  final isEdit = offer != null;
  final locales = ref.read(businessLocalesProvider);
  var titleValues = LocalizedText.initialValues(
    defaultLocale: locales.defaultLocale,
    enabledLocales: locales.enabledLocales,
    i18n: offer?.titleI18n,
    primary: offer?.title,
  );
  var descValues = LocalizedText.initialValues(
    defaultLocale: locales.defaultLocale,
    enabledLocales: locales.enabledLocales,
    i18n: offer?.descriptionI18n,
    primary: offer?.description,
  );

  final products = (ref.read(productsListProvider).valueOrNull ?? [])
      .where((p) => p.status == ProductStatus.active)
      .toList();

  final drafts = <String, _ProductDiscountDraft>{};
  if (offer != null) {
    for (final item in offer.items) {
      final product = products.cast<Product?>().firstWhere(
            (p) => p?.id == item.productId,
            orElse: () => null,
          );
      if (product == null) continue;
      drafts[item.productId] = _ProductDiscountDraft(
        product: product,
        mode: item.mode,
        percent: item.discountPercent ?? offer.discountPercent ?? 10,
        salePrice: item.salePriceEur,
      );
    }
  }

  var durationDays = offer?.durationDays ?? 7;
  var active = offer?.active ?? true;

  final ok = await showAppSideSheet<bool>(
    context: context,
    title: isEdit ? l10n.offerEditTitle : l10n.offerAddTitle,
    saveLabel: isEdit ? l10n.saveChanges : l10n.offerSave,
    child: Consumer(
      builder: (context, ref, _) {
        final localeConfig = ref.watch(businessLocalesProvider);
        final colors = context.appColors;

        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.offerSectionDetails,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 16),
                LocalizedFieldsEditor(
                  label: '${l10n.tableName} *',
                  enabledLocales: localeConfig.enabledLocales,
                  values: titleValues,
                  onChanged: (v) => setState(() => titleValues = v),
                ),
                const SizedBox(height: 12),
                LocalizedFieldsEditor(
                  label: l10n.tableDescription,
                  enabledLocales: localeConfig.enabledLocales,
                  values: descValues,
                  multiline: true,
                  onChanged: (v) => setState(() => descValues = v),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.offerSectionDuration,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.offerDurationLabel(durationDays),
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                Slider(
                  value: durationDays.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  label: '$durationDays',
                  onChanged: (v) => setState(() => durationDays = v.round()),
                ),
                if (isEdit && offer.isExpired)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      l10n.offerRenewHint,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: colors.textMuted,
                        height: 1.35,
                      ),
                    ),
                  ),
                AppSwitchRow(
                  label: l10n.offerActive,
                  value: active,
                  onChanged: (v) => setState(() => active = v),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.offerProductsLabel,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                if (products.isEmpty)
                  Text(
                    l10n.offerNoProducts,
                    style: GoogleFonts.inter(color: colors.textMuted),
                  )
                else
                  ...products.map((product) {
                    final selected = drafts.containsKey(product.id);
                    final draft = drafts[product.id];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(product.name),
                              subtitle: Text(
                                '€${(product.basePrice ?? 0).toStringAsFixed(2)}',
                              ),
                              value: selected,
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    drafts[product.id] = _ProductDiscountDraft(
                                      product: product,
                                      salePrice: product.basePrice,
                                    );
                                  } else {
                                    drafts.remove(product.id);
                                  }
                                });
                              },
                            ),
                            if (selected && draft != null) ...[
                              const SizedBox(height: 8),
                              SegmentedButton<OfferDiscountMode>(
                                segments: [
                                  ButtonSegment(
                                    value: OfferDiscountMode.percent,
                                    label: Text(l10n.offerModePercent),
                                  ),
                                  ButtonSegment(
                                    value: OfferDiscountMode.salePrice,
                                    label: Text(l10n.offerModeSalePrice),
                                  ),
                                ],
                                selected: {draft.mode},
                                onSelectionChanged: (s) {
                                  setState(() => draft.mode = s.first);
                                },
                              ),
                              const SizedBox(height: 8),
                              if (draft.mode == OfferDiscountMode.percent)
                                TextFormField(
                                  initialValue: draft.percent.toStringAsFixed(0),
                                  decoration: InputDecoration(
                                    labelText: l10n.offerPercentLabel,
                                    suffixText: '%',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) {
                                    draft.percent =
                                        double.tryParse(v.replaceAll(',', '.')) ?? 0;
                                  },
                                )
                              else
                                TextFormField(
                                  initialValue: (draft.salePrice ??
                                          product.basePrice ??
                                          0)
                                      .toStringAsFixed(2),
                                  decoration: InputDecoration(
                                    labelText: l10n.offerSalePriceLabel,
                                    prefixText: '€ ',
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  onChanged: (v) {
                                    draft.salePrice =
                                        double.tryParse(v.replaceAll(',', '.'));
                                  },
                                ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            );
          },
        );
      },
    ),
    onSave: () async {
      if (drafts.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.offerPickProducts),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }

      final localeConfig = ref.read(businessLocalesProvider);
      final nameError = validateLocalizedRequired(
        values: titleValues,
        defaultLocale: localeConfig.defaultLocale,
        fieldLabel: l10n.tableName,
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

      final packedTitle = LocalizedText.packForSave(
        defaultLocale: localeConfig.defaultLocale,
        enabledLocales: localeConfig.enabledLocales,
        values: titleValues,
      );
      final packedDesc = LocalizedText.packForSave(
        defaultLocale: localeConfig.defaultLocale,
        enabledLocales: localeConfig.enabledLocales,
        values: descValues,
      );

      final items = <OfferItem>[];
      for (final draft in drafts.values) {
        if (draft.mode == OfferDiscountMode.percent) {
          final pct = draft.percent.clamp(0.0, 100.0);
          if (pct <= 0) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.offerInvalidPercent),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return false;
          }
          items.add(OfferItem(productId: draft.product.id, discountPercent: pct));
        } else {
          final price = draft.salePrice;
          final base = draft.product.basePrice ?? 0;
          if (price == null || price < 0) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.offerInvalidPrice),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return false;
          }
          if (price >= base) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      'Sale price must be lower than the regular price (€${base.toStringAsFixed(2)}).',
                  backgroundColor: Colors.red,
                ),
              );
            }
            return false;
          }
          items.add(OfferItem(productId: draft.product.id, salePriceEur: price));
        }
      }

      try {
        final repo = ref.read(offerRepositoryProvider);
        final days = durationDays.clamp(1, 30);
        if (isEdit) {
          await repo.update(
            businessId: businessId,
            previous: offer,
            offer: Offer(
              id: offer.id,
              businessId: businessId,
              title: packedTitle.primary,
              titleI18n: packedTitle.i18n,
              description: packedDesc.primary.isEmpty ? null : packedDesc.primary,
              descriptionI18n: packedDesc.i18n,
              items: items,
              productIds: items.map((i) => i.productId).toList(),
              durationDays: days,
              startsAt: offer.startsAt,
              endsAt: offer.endsAt,
              active: active,
            ),
          );
        } else {
          await repo.create(
            businessId: businessId,
            title: packedTitle.primary,
            titleI18n: packedTitle.i18n,
            description: packedDesc.primary.isEmpty ? null : packedDesc.primary,
            descriptionI18n: packedDesc.i18n,
            items: items,
            durationDays: days,
            active: active,
          );
        }
        return true;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authErrorMessage(e)),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    },
  );

  if (ok == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEdit ? l10n.offerUpdated : l10n.offerSaved)),
    );
  }
}

Future<void> deleteOffer(
  BuildContext context,
  WidgetRef ref,
  Offer offer,
) async {
  final l10n = context.l10n;
  final ok = await showConfirmDeleteDialog(
    context,
    title: l10n.offerDeleteTitle,
    message: l10n.offerDeleteMessage(offer.title),
  );
  if (!ok || !context.mounted) return;

  final businessId = ref.read(currentBusinessIdProvider);
  if (businessId == null) return;

  try {
    await ref.read(offerRepositoryProvider).delete(
          businessId: businessId,
          offerId: offer.id,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.offerDeleted)),
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
