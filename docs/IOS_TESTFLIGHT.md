# iOS TestFlight & App Store (Binisoft Admin)

Bundle ID: `com.jonsport.businessDashboard`  
Display name: **Binisoft Admin**

## Prerequisites

- Mac with Xcode 15+
- Apple Developer Program ($99/year)
- App created in [App Store Connect](https://appstoreconnect.apple.com) with bundle ID `com.jonsport.businessDashboard`

## Build IPA

```bash
cd "/path/to/Business Dashboard API"
flutter pub get
./tool/build_ios_release.sh
```

Output: `build/ios/ipa/*.ipa`

## Upload to TestFlight

### Option A — Xcode (recommended first time)

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select **Any iOS Device (arm64)** as destination.
3. **Product → Archive**.
4. **Distribute App** → **App Store Connect** → Upload.
5. In App Store Connect → **TestFlight**, add internal testers.

### Option B — Command line (after signing is configured in Xcode)

```bash
xcrun altool --upload-app -f build/ios/ipa/*.ipa \
  --type ios \
  --apiKey YOUR_KEY_ID \
  --apiIssuer YOUR_ISSUER_ID
```

(Or use `xcrun notarytool` / Transporter app.)

## Signing notes

- In Xcode: **Runner** target → **Signing & Capabilities** → Team = your Apple team, **Automatically manage signing**.
- First archive may prompt to register the bundle ID.

## After App Store approval

Set numeric App Store ID in `lib/core/constants/app_download_links.dart`:

```dart
static const String iosAppStoreId = '1234567890'; // from App Store Connect
```

Landing **Download** will open the correct App Store page on iPhone.

## Privacy policy (required)

Public URL (deployed with marketing site):

**https://kresha325.github.io/binisoft-ad/privacy.html**

Use this in App Store Connect → App Privacy → Privacy Policy URL.

## Screenshot sizes (App Store)

| Device | Size |
|--------|------|
| iPhone 6.7" | 1290 × 2796 |
| iPhone 6.5" | 1284 × 2778 |
| iPad 12.9" | 2048 × 2732 (optional) |

Capture: Paneli, Porositë, Produktet, Konfigurimi i dyqanit.
