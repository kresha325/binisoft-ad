# Android Play Store (Binisoft Admin)

Package: `com.jonsport.business_dashboard`

## Build release AAB

```bash
cd "/path/to/Business Dashboard API"
flutter pub get
./tool/build_android_release.sh
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## Signing (required for Play Console)

1. Create keystore (once):

```bash
keytool -genkey -v -keystore ~/binisoft-upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties` (do **not** commit):

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/Users/YOU/binisoft-upload-keystore.jks
```

3. Uncomment signing in `android/app/build.gradle.kts` (see comments in that file after running setup).

## Play Console checklist

- App name: **Binisoft Admin**
- Category: Business
- **Privacy policy URL:** https://kresha325.github.io/binisoft-ad/privacy.html
- Screenshots: see **docs/STORE_SCREENSHOTS.md** (phone 1080×1920 — dashboard, products, orders, appointments)
- Feature graphic: 1024×500
- Upload `app-release.aab` to **Production** or **Internal testing**

## After publish

Set Play Store URL in `lib/core/constants/app_download_links.dart`:

```dart
static const String androidPackageId = 'com.jonsport.business_dashboard';
// Play URL is auto-built; optional: set a short link in marketing.
```

Landing page **Download** section will open the store listing automatically.

## iOS (TestFlight)

```bash
./tool/build_ios_release.sh
```

See **docs/IOS_TESTFLIGHT.md**. Set `iosAppStoreId` in `app_download_links.dart` when live.

## Store copy

Ready-made descriptions: **docs/STORE_LISTINGS.md**
