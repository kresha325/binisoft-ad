# Web + mobile (Binisoft Admin)

## Web (tani)

- **Admin:** https://kresha325.github.io/binisoft-ad/app/#/login  
- **PWA:** “Add to Home Screen” në telefon (manifest + ikona në `web/`).  
- **Firestore:** long polling në web për lidhje më të qëndrueshme.

## Mobile admin (tani)

- **Telefon:** hap URL-n e admin-it në browser → menu poshtë (Paneli, Porositë, Produkte, Cilësimet, Më shumë).  
- **Drawer:** të gjitha faqet (Punëtorët, Oferta, etj.) nga “Më shumë”.

## Native app (hapi tjetër)

| Platformë | Paketa / ID | Status |
|-----------|-------------|--------|
| Android | `com.jonsport.business_dashboard` | Build: `flutter build apk --release` |
| iOS | (bundle në `ios/`) | Duhet Apple Developer + `flutter build ipa` |
| App Store | `AppDownloadLinks.iosAppStoreId` | Bosh derisa publikohet |

Pas publikimit, vendos ID në `lib/core/constants/app_download_links.dart`.

## Checklist publikimi dyqani

Në **Paneli**, karta “Publikimi i dyqanit” kontrollon slug, logo, katalog, kontakt dhe lidhjen me faqen publike.

## Dyqani publik (marketplace)

- URL: `https://kresha325.github.io/Binisoft-marketplace/{slug}`  
- Seksioni **Ekipi:** foto + emër (pa email/telefon).
