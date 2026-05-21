import 'package:equatable/equatable.dart';

import 'site_cta_target.dart';

/// Public storefront theme (CSS variables on shop).
class SiteTheme extends Equatable {
  const SiteTheme({
    this.primary = '#1c1917',
    this.accent = '#ff6b35',
    this.background = '#ffffff',
    this.text = '#111827',
  });

  final String primary;
  final String accent;
  final String background;
  final String text;

  SiteTheme copyWith({
    String? primary,
    String? accent,
    String? background,
    String? text,
  }) =>
      SiteTheme(
        primary: primary ?? this.primary,
        accent: accent ?? this.accent,
        background: background ?? this.background,
        text: text ?? this.text,
      );

  @override
  List<Object?> get props => [primary, accent, background, text];
}

class SiteGalleryItem extends Equatable {
  const SiteGalleryItem({
    this.imageUrl,
    this.youtubeUrl,
    this.caption,
  });

  final String? imageUrl;
  final String? youtubeUrl;
  final String? caption;

  SiteGalleryItem copyWith({
    String? imageUrl,
    String? youtubeUrl,
    String? caption,
  }) =>
      SiteGalleryItem(
        imageUrl: imageUrl ?? this.imageUrl,
        youtubeUrl: youtubeUrl ?? this.youtubeUrl,
        caption: caption ?? this.caption,
      );

  @override
  List<Object?> get props => [imageUrl, youtubeUrl, caption];
}

/// One configurable block on the public shop (hero, products, gallery, …).
class SiteSectionConfig extends Equatable {
  const SiteSectionConfig({
    required this.id,
    this.enabled = true,
    this.title,
    this.description,
    this.navLabel,
    this.imageUrl,
    this.useProfileCover = true,
    this.galleryItems = const [],
    this.ctaLabel,
    this.secondaryCtaLabel,
    this.ctaTarget,
    this.secondaryCtaTarget,
    this.trustBullets = const [],
  });

  final String id;
  final bool enabled;
  final String? title;
  final String? description;
  final String? navLabel;
  final String? imageUrl;
  final bool useProfileCover;
  final List<SiteGalleryItem> galleryItems;
  /// Primary button label (hero, contact WhatsApp, etc.).
  final String? ctaLabel;
  /// Hero secondary button (e.g. services).
  final String? secondaryCtaLabel;
  /// Where the primary CTA navigates (products, contact, whatsapp, …).
  final SiteCtaTarget? ctaTarget;
  final SiteCtaTarget? secondaryCtaTarget;
  /// Hero trust bullets (one per line in admin).
  final List<String> trustBullets;

  SiteSectionConfig copyWith({
    bool? enabled,
    String? title,
    String? description,
    String? navLabel,
    String? imageUrl,
    bool? useProfileCover,
    List<SiteGalleryItem>? galleryItems,
    String? ctaLabel,
    String? secondaryCtaLabel,
    SiteCtaTarget? ctaTarget,
    SiteCtaTarget? secondaryCtaTarget,
    List<String>? trustBullets,
  }) =>
      SiteSectionConfig(
        id: id,
        enabled: enabled ?? this.enabled,
        title: title ?? this.title,
        description: description ?? this.description,
        navLabel: navLabel ?? this.navLabel,
        imageUrl: imageUrl ?? this.imageUrl,
        useProfileCover: useProfileCover ?? this.useProfileCover,
        galleryItems: galleryItems ?? this.galleryItems,
        ctaLabel: ctaLabel ?? this.ctaLabel,
        secondaryCtaLabel: secondaryCtaLabel ?? this.secondaryCtaLabel,
        ctaTarget: ctaTarget ?? this.ctaTarget,
        secondaryCtaTarget: secondaryCtaTarget ?? this.secondaryCtaTarget,
        trustBullets: trustBullets ?? this.trustBullets,
      );

  @override
  List<Object?> get props => [
        id,
        enabled,
        title,
        description,
        navLabel,
        imageUrl,
        useProfileCover,
        galleryItems,
        ctaLabel,
        secondaryCtaLabel,
        ctaTarget,
        secondaryCtaTarget,
        trustBullets,
      ];
}

class SiteSocialLink extends Equatable {
  const SiteSocialLink({required this.platform, required this.url});

  final String platform;
  final String url;

  @override
  List<Object?> get props => [platform, url];
}

class SiteConfig extends Equatable {
  const SiteConfig({
    this.theme = const SiteTheme(),
    this.layout = 'default',
    this.sections = const [],
    this.socials = const [],
    this.footerShowLocation = true,
    this.footerShowPhone = true,
    this.footerShowWhatsApp = true,
  });

  final SiteTheme theme;
  final String layout;
  final List<SiteSectionConfig> sections;
  final List<SiteSocialLink> socials;
  final bool footerShowLocation;
  final bool footerShowPhone;
  final bool footerShowWhatsApp;

  static const sectionHero = 'hero';
  static const sectionOffers = 'offers';
  static const sectionContests = 'contests';
  static const sectionJobOpenings = 'jobOpenings';
  static const sectionProducts = 'products';
  static const sectionServices = 'services';
  static const sectionAbout = 'about';
  static const sectionGallery = 'gallery';
  static const sectionContact = 'contact';

  /// Max images/videos per gallery section (admin + public API).
  static const maxGalleryItems = 8;

  static const socialPlatforms = [
    'facebook',
    'instagram',
    'tiktok',
    'youtube',
    'linkedin',
    'x',
    'whatsapp',
  ];

  static SiteConfig defaults() => SiteConfig(
        sections: [
          const SiteSectionConfig(
            id: sectionHero,
            enabled: true,
            useProfileCover: true,
          ),
          const SiteSectionConfig(id: sectionOffers, enabled: true, title: 'Ofertat'),
          const SiteSectionConfig(id: sectionContests, enabled: true, title: 'Konkurset'),
          const SiteSectionConfig(
            id: sectionJobOpenings,
            enabled: true,
            title: 'Konkurse pune',
          ),
          const SiteSectionConfig(
            id: sectionProducts,
            enabled: true,
            title: 'Produktet',
          ),
          const SiteSectionConfig(
            id: sectionServices,
            enabled: true,
            title: 'Shërbimet',
          ),
          const SiteSectionConfig(id: sectionAbout, enabled: true, title: 'Rreth nesh'),
          const SiteSectionConfig(id: sectionGallery, enabled: true, title: 'Galeria'),
          const SiteSectionConfig(
            id: sectionContact,
            enabled: true,
            title: 'Kontakt',
          ),
        ],
      );

  SiteSectionConfig? section(String id) {
    for (final s in sections) {
      if (s.id == id) return s;
    }
    return null;
  }

  SiteConfig copyWith({
    SiteTheme? theme,
    String? layout,
    List<SiteSectionConfig>? sections,
    List<SiteSocialLink>? socials,
    bool? footerShowLocation,
    bool? footerShowPhone,
    bool? footerShowWhatsApp,
  }) =>
      SiteConfig(
        theme: theme ?? this.theme,
        layout: layout ?? this.layout,
        sections: sections ?? this.sections,
        socials: socials ?? this.socials,
        footerShowLocation: footerShowLocation ?? this.footerShowLocation,
        footerShowPhone: footerShowPhone ?? this.footerShowPhone,
        footerShowWhatsApp: footerShowWhatsApp ?? this.footerShowWhatsApp,
      );

  SiteConfig mergeWithDefaults() {
    final defaults = SiteConfig.defaults();
    final byId = {for (final s in sections) s.id: s};
    final merged = defaults.sections.map((d) => byId[d.id] ?? d).toList();
    for (final s in sections) {
      if (!merged.any((m) => m.id == s.id)) merged.add(s);
    }
    return copyWith(sections: merged);
  }

  @override
  List<Object?> get props =>
      [theme, layout, sections, socials, footerShowLocation, footerShowPhone, footerShowWhatsApp];
}
