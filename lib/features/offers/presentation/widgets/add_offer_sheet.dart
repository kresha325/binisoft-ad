import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/auth_error_message.dart';
import '../../../../core/utils/internal_slug.dart';
import '../../../../core/utils/slug.dart';
import '../../../../core/widgets/app_side_sheet.dart';
import '../../../../core/widgets/app_switch_row.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/presentation/providers/products_providers.dart';
import '../../domain/entities/offer.dart';
import 'offer_sheet_helpers.dart';
import 'product_offer_discount_card.dart';

Future<void> showAddOfferSheet(BuildContext context, WidgetRef ref) =>
    showOfferSheet(context, ref);

/// Hap ofertë të shpejtë nga editimi i produktit (vetëm % ose çmim).
Future<void> showQuickOfferForProduct(
  BuildContext context,
  WidgetRef ref, {
  required Product product,
}) =>
    showOfferSheet(context, ref, focusProduct: product);

Future<void> showOfferSheet(
  BuildContext context,
  WidgetRef ref, {
  Offer? offer,
  Product? focusProduct,
}) async {
  final providers = ProviderScope.containerOf(context, listen: false);
  final l10n = context.l10n;
  final isEdit = offer != null;

  final products = (providers.read(productsListProvider).valueOrNull ?? [])
      .where((p) => p.status == ProductStatus.active)
      .toList();

  final drafts = <String, ProductDiscountDraft>{};
  if (offer != null) {
    for (final item in offer.items) {
      final product = products.cast<Product?>().firstWhere(
            (p) => p?.id == item.productId,
            orElse: () => null,
          );
      if (product == null) continue;
      drafts[item.productId] = ProductDiscountDraft(
        product: product,
        mode: item.mode,
        percent: item.discountPercent ?? offer.discountPercent ?? 10,
        salePrice: item.salePriceEur,
      );
    }
  } else if (focusProduct != null) {
    drafts[focusProduct.id] = ProductDiscountDraft.fromProduct(focusProduct);
  }

  final initialTitle = offer?.title ??
      (focusProduct != null
          ? offerTitleFromProducts([focusProduct])
          : '');
  final titleController = TextEditingController(text: initialTitle);
  final searchController = TextEditingController();
  var durationDays = offer?.durationDays ?? 7;
  var active = offer?.active ?? true;
  var titleManual = isEdit;

  final ok = await showAppSideSheet<bool>(
    context: context,
    title: isEdit ? l10n.offerEditTitle : l10n.offerAddTitle,
    saveLabel: isEdit ? l10n.saveChanges : l10n.offerSave,
    child: Consumer(
      builder: (context, ref, _) {
        final colors = context.appColors;
        final businessId = ref.watch(currentBusinessIdProvider);
        if (businessId == null) return const SizedBox.shrink();

        void syncTitleFromDrafts(void Function(void Function()) setState) {
          if (titleManual) return;
          final selected =
              drafts.values.map((d) => d.product).toList(growable: false);
          if (selected.isEmpty) return;
          setState(() {
            titleController.text = offerTitleFromProducts(selected);
          });
        }

        return StatefulBuilder(
          builder: (context, setState) {
            final q = searchController.text.trim().toLowerCase();
            final filtered = q.isEmpty
                ? products
                : products
                    .where(
                      (p) =>
                          p.name.toLowerCase().contains(q) ||
                          p.slug.toLowerCase().contains(q),
                    )
                    .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (focusProduct != null && !isEdit)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      focusProduct.name,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                AppTextField(
                  label: l10n.tableName,
                  controller: titleController,
                  hint: l10n.offerQuickTitleHint,
                  onChanged: (_) => titleManual = true,
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 20),
                Text(
                  l10n.offerProductsLabel,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                if (products.length > 6)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: l10n.offerSearchProducts,
                        prefixIcon: const Icon(Icons.search, size: 20),
                        isDense: true,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                if (products.isEmpty)
                  Text(
                    l10n.offerNoProducts,
                    style: GoogleFonts.inter(color: colors.textMuted),
                  )
                else
                  ...filtered.map((product) {
                    final selected = drafts.containsKey(product.id);
                    final draft = drafts[product.id];
                    return ProductOfferDiscountCard(
                      product: product,
                      selected: selected,
                      draft: draft,
                      onSelectedChanged: (v) {
                        setState(() {
                          if (v) {
                            drafts[product.id] =
                                ProductDiscountDraft.fromProduct(product);
                          } else {
                            drafts.remove(product.id);
                          }
                          syncTitleFromDrafts(setState);
                        });
                      },
                      onDraftChanged: () => setState(() {}),
                    );
                  }),
              ],
            );
          },
        );
      },
    ),
    onSave: () => _saveOffer(
      context: context,
      providers: providers,
      offer: offer,
      isEdit: isEdit,
      titleController: titleController,
      drafts: drafts,
      durationDays: durationDays,
      active: active,
    ),
  );

  titleController.dispose();
  searchController.dispose();

  if (ok == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEdit ? l10n.offerUpdated : l10n.offerSaved)),
    );
  }
}

Future<bool> _saveOffer({
  required BuildContext context,
  required ProviderContainer providers,
  required Offer? offer,
  required bool isEdit,
  required TextEditingController titleController,
  required Map<String, ProductDiscountDraft> drafts,
  required int durationDays,
  required bool active,
}) async {
  final l10n = context.l10n;

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

  final title = titleController.text.trim();
  if (title.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.tableName),
          backgroundColor: Colors.red,
        ),
      );
    }
    return false;
  }

  final businessId = providers.read(currentBusinessIdProvider);
  if (businessId == null) return false;

  final offerRepo = providers.read(offerRepositoryProvider);
  final internalSlug = normalizeInternalSlug(
    isEdit ? offer!.slug : slugify(title),
  );
  if (internalSlug.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.internalSlugTaken),
          backgroundColor: Colors.red,
        ),
      );
    }
    return false;
  }

  final slugTaken = await offerRepo.isSlugTaken(
    businessId: businessId,
    slug: internalSlug,
    excludeOfferId: offer?.id,
  );
  if (slugTaken) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.internalSlugTaken),
          backgroundColor: Colors.red,
        ),
      );
    }
    return false;
  }

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
              content: Text(
                'Sale price must be lower than the regular price (€${base.toStringAsFixed(2)}).',
              ),
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
    final days = durationDays.clamp(1, 30);
    if (isEdit && offer != null) {
      final editing = offer;
      await offerRepo.update(
        businessId: businessId,
        previous: editing,
        offer: Offer(
          id: editing.id,
          businessId: businessId,
          title: title,
          slug: editing.slug,
          titleI18n: editing.titleI18n,
          description: editing.description,
          descriptionI18n: editing.descriptionI18n,
          seoTitle: editing.seoTitle,
          seoDescription: editing.seoDescription,
          seoTitleI18n: editing.seoTitleI18n,
          seoDescriptionI18n: editing.seoDescriptionI18n,
          localizedSlugs: editing.localizedSlugs,
          items: items,
          productIds: items.map((i) => i.productId).toList(),
          durationDays: days,
          startsAt: editing.startsAt,
          endsAt: editing.endsAt,
          active: active,
        ),
      );
    } else {
      await offerRepo.create(
        businessId: businessId,
        title: title,
        slug: internalSlug,
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

  final providers = ProviderScope.containerOf(context, listen: false);
  final businessId = providers.read(currentBusinessIdProvider);
  if (businessId == null) return;

  try {
    await providers.read(offerRepositoryProvider).delete(
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
