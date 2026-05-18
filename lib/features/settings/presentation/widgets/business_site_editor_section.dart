import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_design.dart';
import '../../../../core/widgets/app_section_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/image_url_upload_row.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../business/domain/entities/site_config.dart';
import '../../../business/presentation/providers/business_providers.dart';

class BusinessSiteEditorSection extends ConsumerStatefulWidget {
  const BusinessSiteEditorSection({super.key});

  @override
  ConsumerState<BusinessSiteEditorSection> createState() =>
      _BusinessSiteEditorSectionState();
}

class _BusinessSiteEditorSectionState extends ConsumerState<BusinessSiteEditorSection> {
  SiteConfig _config = SiteConfig.defaults();
  bool _initialized = false;
  bool _saving = false;

  final _primary = TextEditingController();
  final _accent = TextEditingController();
  final _background = TextEditingController();
  final _textColor = TextEditingController();
  String _layout = 'default';

  final Map<String, _SectionFields> _sections = {};
  final Map<String, TextEditingController> _socialUrls = {};
  final Set<String> _activeSocials = {};

  @override
  void dispose() {
    _primary.dispose();
    _accent.dispose();
    _background.dispose();
    _textColor.dispose();
    for (final f in _sections.values) {
      f.dispose();
    }
    for (final c in _socialUrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  _SectionFields _fieldsFor(String id) =>
      _sections.putIfAbsent(id, () => _SectionFields());

  void _loadFromBusiness() {
    final business = ref.read(currentBusinessProvider).valueOrNull;
    if (business == null || _initialized) return;

    _config = (business.siteConfig ?? SiteConfig.defaults()).mergeWithDefaults();
    _primary.text = _config.theme.primary;
    _accent.text = _config.theme.accent;
    _background.text = _config.theme.background;
    _textColor.text = _config.theme.text;
    _layout = _config.layout;

    for (final s in _config.sections) {
      final f = _fieldsFor(s.id);
      f.enabled = s.enabled;
      f.title.text = s.title ?? '';
      f.description.text = s.description ?? '';
      f.navLabel.text = s.navLabel ?? '';
      f.imageUrl.text = s.imageUrl ?? '';
      f.useProfileCover = s.useProfileCover;
      f.galleryItems
        ..clear()
        ..addAll(s.galleryItems);
    }

    _activeSocials.clear();
    for (final key in SiteConfig.socialPlatforms) {
      _socialUrls.putIfAbsent(key, () => TextEditingController());
    }
    for (final s in _config.socials) {
      _activeSocials.add(s.platform);
      _socialUrls[s.platform]?.text = s.url;
    }

    _initialized = true;
    setState(() {});
  }

  SiteConfig _buildConfig() {
    final sections = SiteConfig.defaults().sections.map((template) {
      final f = _fieldsFor(template.id);
      return SiteSectionConfig(
        id: template.id,
        enabled: f.enabled,
        title: f.title.text.trim().isEmpty ? null : f.title.text.trim(),
        description:
            f.description.text.trim().isEmpty ? null : f.description.text.trim(),
        navLabel: f.navLabel.text.trim().isEmpty ? null : f.navLabel.text.trim(),
        imageUrl: f.imageUrl.text.trim().isEmpty ? null : f.imageUrl.text.trim(),
        useProfileCover: f.useProfileCover,
        galleryItems: List<SiteGalleryItem>.from(f.galleryItems),
      );
    }).toList();

    final socials = <SiteSocialLink>[];
    for (final platform in _activeSocials) {
      final url = _socialUrls[platform]?.text.trim() ?? '';
      if (url.isNotEmpty) socials.add(SiteSocialLink(platform: platform, url: url));
    }

    return SiteConfig(
      theme: SiteTheme(
        primary: _primary.text.trim(),
        accent: _accent.text.trim(),
        background: _background.text.trim(),
        text: _textColor.text.trim(),
      ),
      layout: _layout,
      sections: sections,
      socials: socials,
      footerShowLocation: _config.footerShowLocation,
      footerShowPhone: _config.footerShowPhone,
      footerShowWhatsApp: _config.footerShowWhatsApp,
    );
  }

  Future<String?> _uploadIfPicked({
    required String businessId,
    required PlatformFile? file,
    required String existingUrl,
  }) async {
    if (file == null) return existingUrl.trim().isEmpty ? null : existingUrl.trim();
    var url = await ref.read(mediaUploadServiceProvider).uploadSiteAsset(
          businessId: businessId,
          file: file,
        );
    if (url.contains('firebasestorage')) {
      url = await ref.read(mediaUploadServiceProvider).resolveImageUrl(url);
    }
    return url;
  }

  Future<void> _save() async {
    final businessId = ref.read(currentBusinessIdProvider);
    if (businessId == null) return;

    setState(() => _saving = true);
    try {
      for (final entry in _sections.entries) {
        final f = entry.value;
        if (f.imageFile != null) {
          final url = await _uploadIfPicked(
            businessId: businessId,
            file: f.imageFile,
            existingUrl: f.imageUrl.text,
          );
          if (url != null) f.imageUrl.text = url;
          f.imageFile = null;
        }
        for (var i = 0; i < f.galleryItems.length; i++) {
          final gf = f.galleryFiles[i];
          if (gf != null) {
            final url = await _uploadIfPicked(
              businessId: businessId,
              file: gf,
              existingUrl: f.galleryItems[i].imageUrl ?? '',
            );
            f.galleryItems[i] = f.galleryItems[i].copyWith(imageUrl: url);
            f.galleryFiles[i] = null;
          }
        }
      }

      await ref.read(businessRepositoryProvider).updateSiteConfig(
            businessId: businessId,
            siteConfig: _buildConfig(),
          );
      ref.invalidate(currentBusinessProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.siteEditorSaved)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'),
            backgroundColor: context.appColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFromBusiness());

    return AppSectionCard(
      title: l10n.siteEditorTitle,
      subtitle: l10n.siteEditorSubtitle,
      icon: Icons.palette_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.siteEditorColorsTitle,
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 12),
          _ColorField(label: l10n.siteEditorColorPrimary, controller: _primary),
          const SizedBox(height: 12),
          _ColorField(label: l10n.siteEditorColorAccent, controller: _accent),
          const SizedBox(height: 12),
          _ColorField(label: l10n.siteEditorColorBackground, controller: _background),
          const SizedBox(height: 12),
          _ColorField(label: l10n.siteEditorColorText, controller: _textColor),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _layout,
            decoration: InputDecoration(labelText: l10n.siteEditorLayoutLabel),
            items: [
              DropdownMenuItem(value: 'default', child: Text(l10n.siteEditorLayoutDefault)),
              DropdownMenuItem(value: 'wide', child: Text(l10n.siteEditorLayoutWide)),
            ],
            onChanged: (v) => setState(() => _layout = v ?? 'default'),
          ),
          const SizedBox(height: 24),
          Text(l10n.siteEditorSectionsTitle,
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          ..._config.mergeWithDefaults().sections.map((s) => _SectionTile(
                sectionId: s.id,
                fields: _fieldsFor(s.id),
                onChanged: () => setState(() {}),
              )),
          const SizedBox(height: 24),
          Text(l10n.siteEditorSocialsTitle,
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SiteConfig.socialPlatforms.map((platform) {
              final selected = _activeSocials.contains(platform);
              return FilterChip(
                label: Text(_socialLabel(l10n, platform)),
                selected: selected,
                onSelected: (on) {
                  setState(() {
                    if (on) {
                      _activeSocials.add(platform);
                      _socialUrls.putIfAbsent(platform, () => TextEditingController());
                    } else {
                      _activeSocials.remove(platform);
                    }
                  });
                },
              );
            }).toList(),
          ),
          for (final platform in _activeSocials) ...[
            const SizedBox(height: 12),
            AppTextField(
              label: '${_socialLabel(l10n, platform)} URL',
              controller: _socialUrls[platform]!,
              hint: 'https://',
              keyboardType: TextInputType.url,
            ),
          ],
          const SizedBox(height: 20),
          Text(l10n.siteEditorFooterTitle,
              style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.siteEditorFooterLocation),
            value: _config.footerShowLocation,
            onChanged: (v) => setState(() => _config = _config.copyWith(footerShowLocation: v)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.siteEditorFooterPhone),
            value: _config.footerShowPhone,
            onChanged: (v) => setState(() => _config = _config.copyWith(footerShowPhone: v)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.siteEditorFooterWhatsApp),
            value: _config.footerShowWhatsApp,
            onChanged: (v) =>
                setState(() => _config = _config.copyWith(footerShowWhatsApp: v)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(l10n.siteEditorSaveButton),
            ),
          ),
        ],
      ),
    );
  }

  String _socialLabel(dynamic l10n, String platform) {
    switch (platform) {
      case 'facebook':
        return l10n.siteSocialFacebook;
      case 'instagram':
        return l10n.siteSocialInstagram;
      case 'tiktok':
        return l10n.siteSocialTiktok;
      case 'youtube':
        return l10n.siteSocialYoutube;
      case 'linkedin':
        return l10n.siteSocialLinkedin;
      case 'x':
        return l10n.siteSocialX;
      case 'whatsapp':
        return l10n.siteSocialWhatsapp;
      default:
        return platform;
    }
  }
}

class _SectionFields {
  bool enabled = true;
  bool useProfileCover = true;
  final title = TextEditingController();
  final description = TextEditingController();
  final navLabel = TextEditingController();
  final imageUrl = TextEditingController();
  PlatformFile? imageFile;
  final galleryItems = <SiteGalleryItem>[];
  final galleryFiles = <PlatformFile?>[];

  void dispose() {
    title.dispose();
    description.dispose();
    navLabel.dispose();
    imageUrl.dispose();
  }
}

class _ColorField extends StatelessWidget {
  const _ColorField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    Color? preview;
    try {
      final hex = controller.text.trim().replaceFirst('#', '');
      if (hex.length == 6) {
        preview = Color(int.parse('FF$hex', radix: 16));
      }
    } catch (_) {}

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (preview != null)
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(top: 28, right: 8),
            decoration: BoxDecoration(
              color: preview,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.cardBorder),
            ),
          ),
        Expanded(
          child: AppTextField(
            label: label,
            controller: controller,
            hint: '#0a1628',
          ),
        ),
      ],
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({
    required this.sectionId,
    required this.fields,
    required this.onChanged,
  });

  final String sectionId;
  final _SectionFields fields;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = _sectionTitle(l10n, sectionId);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesign.radiusMd),
      ),
      child: ExpansionTile(
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        subtitle: Text(
          fields.enabled ? l10n.siteSectionEnabled : l10n.siteSectionDisabled,
          style: GoogleFonts.inter(fontSize: 12, color: context.appColors.textMuted),
        ),
        children: [
          SwitchListTile(
            title: Text(l10n.siteSectionShowOnSite),
            value: fields.enabled,
            onChanged: (v) {
              fields.enabled = v;
              onChanged();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppTextField(
              label: l10n.siteSectionNavLabel,
              controller: fields.navLabel,
              hint: title,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppTextField(
              label: sectionId == SiteConfig.sectionHero
                  ? l10n.siteSectionHeroH1
                  : l10n.siteSectionTitle,
              controller: fields.title,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppTextField(
              label: sectionId == SiteConfig.sectionHero
                  ? l10n.siteSectionHeroP
                  : l10n.siteSectionDescription,
              controller: fields.description,
              maxLines: 3,
            ),
          ),
          if (sectionId == SiteConfig.sectionHero) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.siteHeroUseProfileCover),
                value: fields.useProfileCover,
                onChanged: (v) {
                  fields.useProfileCover = v;
                  onChanged();
                },
              ),
            ),
            if (!fields.useProfileCover) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ImageUrlUploadRow(
                  label: l10n.siteHeroImage,
                  urlController: fields.imageUrl,
                  onFilePicked: (f) {
                    fields.imageFile = f;
                    onChanged();
                  },
                  fileName: fields.imageFile?.name,
                ),
              ),
            ],
          ],
          if (sectionId == SiteConfig.sectionGallery) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.siteGalleryHint,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: context.appColors.textMuted,
                ),
              ),
            ),
            ...List.generate(fields.galleryItems.length, (i) {
              return _GalleryItemEditor(
                index: i,
                item: fields.galleryItems[i],
                onImagePicked: (f) {
                  while (fields.galleryFiles.length <= i) {
                    fields.galleryFiles.add(null);
                  }
                  fields.galleryFiles[i] = f;
                  onChanged();
                },
                onUpdate: (item) {
                  fields.galleryItems[i] = item;
                  onChanged();
                },
                onRemove: () {
                  fields.galleryItems.removeAt(i);
                  if (i < fields.galleryFiles.length) fields.galleryFiles.removeAt(i);
                  onChanged();
                },
              );
            }),
            if (fields.galleryItems.length < 5)
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton.icon(
                  onPressed: () {
                    fields.galleryItems.add(const SiteGalleryItem());
                    fields.galleryFiles.add(null);
                    onChanged();
                  },
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: Text(l10n.siteGalleryAdd),
                ),
              ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _sectionTitle(dynamic l10n, String id) {
    switch (id) {
      case SiteConfig.sectionHero:
        return l10n.siteSectionHero;
      case SiteConfig.sectionOffers:
        return l10n.siteSectionOffers;
      case SiteConfig.sectionProducts:
        return l10n.siteSectionProducts;
      case SiteConfig.sectionAbout:
        return l10n.siteSectionAbout;
      case SiteConfig.sectionGallery:
        return l10n.siteSectionGallery;
      case SiteConfig.sectionContact:
        return l10n.siteSectionContact;
      default:
        return id;
    }
  }
}

class _GalleryItemEditor extends StatefulWidget {
  const _GalleryItemEditor({
    required this.index,
    required this.item,
    required this.onImagePicked,
    required this.onUpdate,
    required this.onRemove,
  });

  final int index;
  final SiteGalleryItem item;
  final void Function(PlatformFile file) onImagePicked;
  final void Function(SiteGalleryItem item) onUpdate;
  final VoidCallback onRemove;

  @override
  State<_GalleryItemEditor> createState() => _GalleryItemEditorState();
}

class _GalleryItemEditorState extends State<_GalleryItemEditor> {
  late final TextEditingController _imageUrl;
  late final TextEditingController _youtube;
  late final TextEditingController _caption;
  PlatformFile? _file;

  @override
  void initState() {
    super.initState();
    _imageUrl = TextEditingController(text: widget.item.imageUrl ?? '');
    _youtube = TextEditingController(text: widget.item.youtubeUrl ?? '');
    _caption = TextEditingController(text: widget.item.caption ?? '');
  }

  @override
  void dispose() {
    _imageUrl.dispose();
    _youtube.dispose();
    _caption.dispose();
    super.dispose();
  }

  void _sync() {
    widget.onUpdate(
      SiteGalleryItem(
        imageUrl: _imageUrl.text.trim().isEmpty ? null : _imageUrl.text.trim(),
        youtubeUrl: _youtube.text.trim().isEmpty ? null : _youtube.text.trim(),
        caption: _caption.text.trim().isEmpty ? null : _caption.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: context.appColors.cardBorder),
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('${l10n.siteGalleryItem} ${widget.index + 1}',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            ImageUrlUploadRow(
              label: l10n.siteGalleryImage,
              urlController: _imageUrl,
              onFilePicked: (f) {
                _file = f;
                widget.onImagePicked(f);
                _sync();
              },
              fileName: _file?.name,
            ),
            const SizedBox(height: 8),
            AppTextField(
              label: l10n.siteGalleryYoutube,
              controller: _youtube,
              hint: 'https://youtube.com/watch?v=…',
              onChanged: (_) => _sync(),
            ),
            const SizedBox(height: 8),
            AppTextField(
              label: l10n.siteGalleryCaption,
              controller: _caption,
              onChanged: (_) => _sync(),
            ),
          ],
        ),
      ),
    );
  }
}
