# Business Dashboard — Multi-tenant SaaS (Flutter + Firebase)

Admin dashboard for **jon-sport** Firebase project. Each business is a tenant under `businesses/{businessId}/…`.

## Stack

- Flutter (Web + Android + iOS)
- Riverpod + go_router
- Firebase Auth, Firestore (`nam5`), Storage
- Clean architecture (`data` / `domain` / `presentation`)

## Your setup (required once)

### 1. Add Web app in Firebase

[Project settings](https://console.firebase.google.com/project/jon-sport/settings/general) → **Add app** → Web.

### 2. FlutterFire

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=jon-sport
```

This replaces `lib/config/firebase_options.dart` with real keys.

### 3. Deploy security rules

```bash
npm i -g firebase-tools
firebase login
firebase use jon-sport
firebase deploy --only firestore:rules,firestore:indexes,storage
```

### 4. Fix web login 403 / 400 (GitHub Pages only)

**Dashboard URL (use this):** https://kresha325.github.io/binisoft-ad/

Do not use `jon-sport.web.app` for the admin UI unless you add that domain in Firebase (this project uses GitHub Pages only).

In [Google Cloud Console → Credentials](https://console.cloud.google.com/apis/credentials?project=jon-sport), open the **Browser API key** (web `apiKey` in `lib/firebase_options.dart`). Under **HTTP referrers** add:

- `http://localhost:*`
- `http://127.0.0.1:*`
- `https://kresha325.github.io/*`

Under **API restrictions**, either **Don’t restrict key** or ensure **Identity Toolkit API** is allowed.

In [Firebase Auth → Authorized domains](https://console.firebase.google.com/project/jon-sport/authentication/settings):

- `kresha325.github.io`
- `localhost`

Enable **Email/Password** in [Sign-in method](https://console.firebase.google.com/project/jon-sport/authentication/providers).

Hard refresh: `Cmd+Shift+R` on the GitHub Pages login URL.

## Deploy web (GitHub Pages)

Public URL: **https://kresha325.github.io/binisoft-ad/**

1. In the repo on GitHub: **Settings → Pages → Build and deployment → Source** → **GitHub Actions**.
2. Push to `main` (workflow `.github/workflows/deploy-github-pages.yml` builds Flutter web with `--base-href "/binisoft-ad/"` and deploys).
3. First deploy: **Actions** tab → wait for **Deploy Web to GitHub Pages** to finish (green).
4. Add Firebase / API referrers above so Auth works on the live URL.

Manual build (same as CI):

```bash
flutter build web --release --pwa-strategy=none --base-href "/binisoft-ad/"
dart run tool/patch_web_bootstrap.dart
cp build/web/index.html build/web/404.html
```

### 5. Run app

```bash
flutter pub get
flutter run -d chrome
```

## Register flow

1. **Register** → Firebase Auth user + `businesses/{businessId}` + `users/{uid}` (role: `owner`)
2. All catalog data lives under `businesses/{businessId}/products`, `categories`, etc.

## Firestore layout

```
users/{uid}                    → businessId, role, email
businesses/{businessId}        → name, ownerId, slug
  ├── products/
  ├── categories/
  ├── productVariants/
  ├── attributes/
  ├── attributeValues/
  ├── media/
  ├── apiKeys/
  └── settings/
```

Legacy `social_posts` is blocked by rules for new app users.

## Deploy (production)

See **[DEPLOY.md](DEPLOY.md)** for rules, functions, GitHub Pages, and env vars.

**CI:** every push/PR runs `flutter analyze`, `flutter test`, and `functions` tests.

## Implemented

- Public API (`/products`, `/categories`, `/offers`, `/orders`) via `publicApi`
- Offers with sale pricing on catalog (`onOffer`, `originalPrice`) — products stay active
- API keys, billing/invoices (demo payments), notifications, multi-locale ARB

## Roadmap

- Stripe (real payments)
- Team roles: owner/admin invite manager & employee (`/join` + Settings → Team)
- Broader i18n (superadmin, landing) · monitoring (Crashlytics/Sentry)
