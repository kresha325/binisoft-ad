import 'entities/business_type.dart';
import 'entities/site_config.dart';
import 'entities/site_cta_target.dart';

/// Suggested hero / contact button copy and actions by business category.
class SiteHeroCtaPreset {
  const SiteHeroCtaPreset({
    required this.primaryLabel,
    required this.primaryTarget,
    this.secondaryLabel,
    this.secondaryTarget,
    this.trustBullets = const [],
  });

  final String primaryLabel;
  final SiteCtaTarget primaryTarget;
  final String? secondaryLabel;
  final SiteCtaTarget? secondaryTarget;
  final List<String> trustBullets;
}

class SiteCtaPresets {
  SiteCtaPresets._();

  static const _genericOrderLabels = {
    'porosit tani',
    'shiko produktet',
    'porosit online',
    'order now',
    'view products',
  };

  static bool isGenericOrderLabel(String? label) {
    final n = label?.trim().toLowerCase() ?? '';
    return n.isNotEmpty && _genericOrderLabels.contains(n);
  }

  static String contactLabelFor(BusinessType? type) {
    return switch (_category(type)) {
      _CtaCategory.appointment => 'Na kontaktoni',
      _CtaCategory.foodOrder => 'Porosit në WhatsApp',
      _CtaCategory.retailOrder => 'Na shkruani në WhatsApp',
      _CtaCategory.contactLead => 'Na kontaktoni',
    };
  }

  static SiteHeroCtaPreset heroFor(BusinessType? type) {
    return switch (_category(type)) {
      _CtaCategory.foodOrder => const SiteHeroCtaPreset(
          primaryLabel: 'Porosit tani',
          primaryTarget: SiteCtaTarget.products,
          secondaryLabel: 'Shërbimet',
          secondaryTarget: SiteCtaTarget.services,
          trustBullets: [
            'Porosi online',
            'Menu & oferta',
            'Kontakt i shpejtë',
          ],
        ),
      _CtaCategory.retailOrder => const SiteHeroCtaPreset(
          primaryLabel: 'Shiko produktet',
          primaryTarget: SiteCtaTarget.products,
          secondaryLabel: 'Ofertat',
          secondaryTarget: SiteCtaTarget.offers,
          trustBullets: [
            'Produkte të zgjedhura',
            'Porosi online',
            'Çmime transparente',
          ],
        ),
      _CtaCategory.appointment => SiteHeroCtaPreset(
          primaryLabel: type == BusinessType.clinic
              ? 'Rezervo termin'
              : 'Rezervo termin',
          primaryTarget: SiteCtaTarget.whatsapp,
          secondaryLabel: 'Shërbimet',
          secondaryTarget: SiteCtaTarget.services,
          trustBullets: type == BusinessType.clinic
              ? const [
                  'Termine & konsultime',
                  'Na kontaktoni',
                  'Lokacion i qartë',
                ]
              : const [
                  'Rezervim i lehtë',
                  'Na kontaktoni',
                  'Orar i përshtatshëm',
                ],
        ),
      _CtaCategory.contactLead => SiteHeroCtaPreset(
          primaryLabel: type == BusinessType.hotel
              ? 'Rezervo qëndrimin'
              : type == BusinessType.realEstate
                  ? 'Na kontaktoni'
                  : 'Na kontaktoni',
          primaryTarget: type == BusinessType.hotel
              ? SiteCtaTarget.contact
              : SiteCtaTarget.contact,
          secondaryLabel: 'Shërbimet',
          secondaryTarget: SiteCtaTarget.services,
          trustBullets: const [
            'Përgjigje e shpejtë',
            'Eksperiencë profesionale',
            'Na vizitoni',
          ],
        ),
    };
  }

  /// Fills empty CTA fields; replaces generic “order” labels for non-retail types.
  static SiteConfig applyTo(SiteConfig config, BusinessType? type) {
    final preset = heroFor(type);
    final contactLabel = contactLabelFor(type);
    final allowOrderCopy = _category(type) == _CtaCategory.foodOrder ||
        _category(type) == _CtaCategory.retailOrder;

    final sections = config.sections.map((s) {
      if (s.id == SiteConfig.sectionHero) {
        var label = s.ctaLabel;
        var target = s.ctaTarget;
        var secLabel = s.secondaryCtaLabel;
        var secTarget = s.secondaryCtaTarget;
        var bullets = s.trustBullets;

        if (label == null || label.trim().isEmpty) {
          label = preset.primaryLabel;
        } else if (!allowOrderCopy && isGenericOrderLabel(label)) {
          label = preset.primaryLabel;
        }
        target ??= preset.primaryTarget;
        if (secLabel == null || secLabel.trim().isEmpty) {
          secLabel = preset.secondaryLabel;
        }
        secTarget ??= preset.secondaryTarget;
        if (bullets.isEmpty) bullets = preset.trustBullets;

        return s.copyWith(
          ctaLabel: label,
          ctaTarget: target,
          secondaryCtaLabel: secLabel,
          secondaryCtaTarget: secTarget,
          trustBullets: bullets,
        );
      }
      if (s.id == SiteConfig.sectionContact) {
        var label = s.ctaLabel;
        if (label == null || label.trim().isEmpty) {
          label = contactLabel;
        }
        return s.copyWith(ctaLabel: label);
      }
      return s;
    }).toList();

    return config.copyWith(sections: sections);
  }

  static _CtaCategory _category(BusinessType? type) {
    if (type == null) return _CtaCategory.contactLead;
    if (_foodOrder.contains(type)) return _CtaCategory.foodOrder;
    if (_retailOrder.contains(type)) return _CtaCategory.retailOrder;
    if (_appointment.contains(type)) return _CtaCategory.appointment;
    return _CtaCategory.contactLead;
  }

  static const _foodOrder = {
    BusinessType.restaurant,
    BusinessType.pizzeria,
    BusinessType.cafe,
    BusinessType.fastFood,
    BusinessType.bar,
    BusinessType.catering,
    BusinessType.iceCream,
  };

  static const _retailOrder = {
    BusinessType.retail,
    BusinessType.fashion,
    BusinessType.electronics,
    BusinessType.grocery,
    BusinessType.bakery,
    BusinessType.wholesale,
    BusinessType.butcher,
    BusinessType.flowerShop,
    BusinessType.jewelry,
    BusinessType.bookstore,
    BusinessType.pharmacy,
    BusinessType.agriculture,
    BusinessType.petShop,
  };

  static const _appointment = {
    BusinessType.services,
    BusinessType.salon,
    BusinessType.spa,
    BusinessType.clinic,
    BusinessType.fitness,
    BusinessType.education,
    BusinessType.automotive,
  };
}

enum _CtaCategory {
  foodOrder,
  retailOrder,
  appointment,
  contactLead,
}
