# Screenshots për Play Store & App Store

Merrni **5–8 foto** të qarta. Më poshtë: madhësitë, URL-të, dhe rendi i rekomanduar.

## Admin (Flutter web — më e shpejta)

1. Nis admin në Chrome me viewport telefoni:

```bash
./tool/dev_run_chrome.sh
# ose: flutter run -d chrome --web-port=8080
```

2. Chrome DevTools → **Toggle device toolbar** (iPhone 14 Pro: 393×852 ose Pixel 7).

3. Hap këto faqe dhe bëj screenshot (`Cmd+Shift+4` ose DevTools → ⋮ → Capture screenshot):

| # | URL / rrugë | Çfarë të duket |
|---|-------------|----------------|
| 1 | `…/binisoft-ad/app/#/login` | Hyrja |
| 2 | `…/app/#/dashboard` | Paneli + statistika |
| 3 | `…/app/#/onboarding` | Konfigurimi 3/5 (nëse ka hapa të paplotë) |
| 4 | `…/app/#/products` | Lista produktesh |
| 5 | `…/app/#/orders` | Porositë (karta mobile) |
| 6 | `…/app/#/appointments` | Terminet + kalendar |
| 7 | `…/app/#/settings` | Cilësimet / faqja e dyqanit |

**Bazë URL:** https://kresha325.github.io/binisoft-ad/app/

## Dyqani publik (marketplace)

| # | URL | Çfarë |
|---|-----|--------|
| 8 | `https://kresha325.github.io/Binisoft-marketplace/{slug}` | Faqja e dyqanit (produkte) |
| 9 | E njëjta `#team` ose seksioni Ekipi | Ekipi (nëse aktiv) |

Zëvendëso `{slug}` me slug-in të biznesit demo (p.sh. `napoletana`).

## Madhësi për dyqanet

### Google Play

| Aset | Madhësia |
|------|----------|
| Telefon | min. 1080 × 1920 (2:3 deri 9:16) |
| Feature graphic | 1024 × 500 |
| Ikonë | 512×512 (nga `flutter_launcher_icons`) |

### Apple App Store

| Aset | Madhësia |
|------|----------|
| iPhone 6.7" | 1290 × 2796 |
| iPhone 6.5" | 1284 × 2778 (nëse kërkohet) |

## Resize (opsional, macOS `sips`)

```bash
# Shembull: crop në raport 9:16 nga screenshot desktop
sips -z 1920 1080 input.png --out play-phone.png
```

## Aplikacion native (më vonë)

Kur keni build në telefon:

```bash
flutter run -d <device_id>
```

Bëni të njëjtat ekrane si tabela më sipër — pamja duhet të përputhet me web-in.

## Checklist para ngarkimit

- [ ] Pa të dhëna sensitive (telefon/email klientësh realë)  
- [ ] Mënyra e errët ose e çelët konsistente (admin dark rekomandohet)  
- [ ] Status bar / URL bar i pastër (DevTools fullscreen)  
- [ ] Tekst në shqip ose anglisht — një gjuhë në të gjitha fotot  

Tekst për listime: **docs/STORE_LISTINGS.md**
