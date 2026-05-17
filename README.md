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

### 4. Fix web HTTP 400 (if login/register fails in Chrome)

In [Google Cloud Console → Credentials](https://console.cloud.google.com/apis/credentials?project=jon-sport), open the **Browser API key** used by your Web app and under **Application restrictions → HTTP referrers** add:

- `http://localhost:*`
- `http://127.0.0.1:*`

In [Firebase Auth → Settings → Authorized domains](https://console.firebase.google.com/project/jon-sport/authentication/settings), ensure `localhost` is listed.

Then hard refresh Chrome (`Cmd+Shift+R`).

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

## Next phases

- Cloud Functions (API `/products`, custom claims)
- Variant generator UI, media upload (WebP)
- User management, API keys, analytics
