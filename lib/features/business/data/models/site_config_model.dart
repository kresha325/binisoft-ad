import '../../domain/entities/site_config.dart';

class SiteConfigModel {
  static SiteConfig fromMap(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return SiteConfig.defaults();

    final themeRaw = data['theme'];
    final theme = themeRaw is Map
        ? SiteTheme(
            primary: _str(themeRaw['primary'], '#0a1628'),
            accent: _str(themeRaw['accent'], '#f5c518'),
            background: _str(themeRaw['background'], '#ffffff'),
            text: _str(themeRaw['text'], '#111827'),
          )
        : const SiteTheme();

    final sectionsRaw = data['sections'];
    final sections = <SiteSectionConfig>[];
    if (sectionsRaw is List) {
      for (final item in sectionsRaw) {
        if (item is! Map) continue;
        final m = Map<String, dynamic>.from(item);
        final galleryRaw = m['galleryItems'];
        final galleryItems = <SiteGalleryItem>[];
        if (galleryRaw is List) {
          for (final g in galleryRaw.take(5)) {
            if (g is! Map) continue;
            final gm = Map<String, dynamic>.from(g);
            galleryItems.add(
              SiteGalleryItem(
                imageUrl: gm['imageUrl'] as String?,
                youtubeUrl: gm['youtubeUrl'] as String?,
                caption: gm['caption'] as String?,
              ),
            );
          }
        }
        sections.add(
          SiteSectionConfig(
            id: m['id'] as String? ?? '',
            enabled: m['enabled'] as bool? ?? true,
            title: m['title'] as String?,
            description: m['description'] as String?,
            navLabel: m['navLabel'] as String?,
            imageUrl: m['imageUrl'] as String?,
            useProfileCover: m['useProfileCover'] as bool? ?? true,
            galleryItems: galleryItems,
          ),
        );
      }
    }

    final socialsRaw = data['socials'];
    final socials = <SiteSocialLink>[];
    if (socialsRaw is List) {
      for (final s in socialsRaw) {
        if (s is! Map) continue;
        final m = Map<String, dynamic>.from(s);
        final platform = m['platform'] as String? ?? '';
        final url = m['url'] as String? ?? '';
        if (platform.isEmpty || url.isEmpty) continue;
        socials.add(SiteSocialLink(platform: platform, url: url));
      }
    }

    final base = sections.isEmpty
        ? SiteConfig.defaults()
        : SiteConfig(sections: sections);
    return base
        .mergeWithDefaults()
        .copyWith(
          theme: theme,
          layout: data['layout'] as String? ?? 'default',
          socials: socials,
          footerShowLocation: data['footerShowLocation'] as bool? ?? true,
          footerShowPhone: data['footerShowPhone'] as bool? ?? true,
          footerShowWhatsApp: data['footerShowWhatsApp'] as bool? ?? true,
        );
  }

  static Map<String, dynamic> toMap(SiteConfig config) {
    final merged = config.mergeWithDefaults();
    return {
      'theme': {
        'primary': merged.theme.primary,
        'accent': merged.theme.accent,
        'background': merged.theme.background,
        'text': merged.theme.text,
      },
      'layout': merged.layout,
      'sections': merged.sections.map((s) {
        return {
          'id': s.id,
          'enabled': s.enabled,
          if (s.title != null && s.title!.isNotEmpty) 'title': s.title,
          if (s.description != null && s.description!.isNotEmpty)
            'description': s.description,
          if (s.navLabel != null && s.navLabel!.isNotEmpty) 'navLabel': s.navLabel,
          if (s.imageUrl != null && s.imageUrl!.isNotEmpty) 'imageUrl': s.imageUrl,
          'useProfileCover': s.useProfileCover,
          if (s.id == SiteConfig.sectionGallery && s.galleryItems.isNotEmpty)
            'galleryItems': s.galleryItems
                .take(5)
                .map((g) => {
                      if (g.imageUrl != null && g.imageUrl!.isNotEmpty)
                        'imageUrl': g.imageUrl,
                      if (g.youtubeUrl != null && g.youtubeUrl!.isNotEmpty)
                        'youtubeUrl': g.youtubeUrl,
                      if (g.caption != null && g.caption!.isNotEmpty) 'caption': g.caption,
                    })
                .toList(),
        };
      }).toList(),
      'socials': merged.socials
          .map((s) => {'platform': s.platform, 'url': s.url})
          .toList(),
      'footerShowLocation': merged.footerShowLocation,
      'footerShowPhone': merged.footerShowPhone,
      'footerShowWhatsApp': merged.footerShowWhatsApp,
    };
  }

  static String _str(dynamic v, String fallback) {
    final s = v?.toString().trim() ?? '';
    return s.isEmpty ? fallback : s;
  }
}
