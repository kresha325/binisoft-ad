# Web + mobile (Binisoft Admin)

## Web (tani)

- **Admin:** https://kresha325.github.io/binisoft-ad/app/#/login  
- **Harrove fjalëkalimin:** …/app/#/forgot-password (email nga **Firebase Auth**, jo email i platformës ende)  
- **PWA:** “Add to Home Screen” në telefon (manifest + ikona në `web/`).  
- **Firestore:** long polling në web për lidhje më të qëndrueshme.

### Rivendos fjalëkalimin (Firebase)

1. Login → **Harrove fjalëkalimin?** ose Cilësimet → **Fjalëkalimi i llogarisë**  
2. Email vjen nga `noreply@jon-sport.firebaseapp.com` (ose template në Firebase Console)  
3. Pas linkut, hyr me fjalëkalimin e ri te `#/login`  

Kur të kesh emailin e platformës (Binisoft), aktivizohet edhe autosend për njoftime — fjalëkalimi mbetet përmes Firebase Auth.

## Play Store (Android)

```bash
./tool/build_android_release.sh
```

Udhëzues: `docs/PLAY_STORE_RELEASE.md` · Listime: `docs/STORE_LISTINGS.md`

## iOS (TestFlight)

```bash
./tool/build_ios_release.sh
```

Udhëzues: `docs/IOS_TESTFLIGHT.md`

## Privatësia (dyqane)

https://kresha325.github.io/binisoft-ad/privacy.html

## Onboarding dyqani

Pas regjistrimit: `/onboarding` — hapat e checklist (slug, logo, katalog, kontakt, preview). Paneli tregon banner “Vazhdo” derisa të përfundojë.

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
