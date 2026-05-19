import 'package:firebase_auth/firebase_auth.dart';

import '../errors/app_exception.dart';

String firebaseAuthErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-credential':
    case 'invalid-login-credentials':
    case 'wrong-password':
      return 'Email ose fjalëkalim i gabuar.';
    case 'user-not-found':
      return 'Nuk ekziston llogari me këtë email. Regjistrohu fillimisht.';
    case 'user-disabled':
      return 'Llogaria është çaktivizuar në Firebase.';
    case 'too-many-requests':
      return 'Shumë përpjekje. Provo përsëri pas disa minutash.';
    case 'operation-not-allowed':
      return 'Email/Password nuk është aktiv në Firebase Console → Authentication → Sign-in method.';
    case 'invalid-email':
      return 'Format email i pavlefshëm.';
    case 'network-request-failed':
      return 'Problem rrjeti. Kontrollo lidhjen dhe provo përsëri.';
    case 'requests-from-referer-are-blocked':
    case 'referer-blocked':
      return 'API key bllokon localhost. Në GCP hap key-in AIzaSyBkH…UdGfU '
          '(firebase_options web) → Application restrictions: None për test, '
          'ose shto http://localhost:8080/* te aty key, jo te një key tjetër.';
    case 'invalid-api-key':
    case 'api-key-not-valid':
      return 'API key i Firebase është i kufizuar. Në Google Cloud Console → Credentials → '
          'Browser key, shto HTTP referrers: http://localhost:*, http://127.0.0.1:* dhe '
          'https://kresha325.github.io/*';
    default:
      return e.message ?? 'Autentifikimi dështoi (${e.code}).';
  }
}

String authErrorMessage(Object error) {
  if (error is AuthException) return error.message;
  if (error is FirebaseAuthException) return firebaseAuthErrorMessage(error);
  final text = error.toString();
  if (text.contains('permission-denied')) {
    return 'Firestore: akses i refuzuar. Deploy rregullat ose kontrollo users/{uid}.';
  }
  if (text.contains('email-already-in-use')) {
    return 'Ky email është i regjistruar. Hyr me fjalëkalim.';
  }
  if ((text.contains('referer') && text.contains('blocked')) ||
      text.contains('API_KEY_HTTP_REFERRER_BLOCKED')) {
    return 'Login 403: localhost nuk është te key-i i duhur në GCP. '
        'Hap key-in AIzaSyBkHpcfoxEZSvmFRKGwUwuO1LnmihUdGfU → None (test) '
        'ose http://localhost:8080/*. Ose: export FIREBASE_WEB_API_KEY=key_dev && ./tool/dev_run_chrome.sh';
  }
  if (text.contains('API key not valid') ||
      text.contains('API_KEY_INVALID') ||
      (text.contains('identitytoolkit') &&
          (text.contains('400') || text.contains('403')))) {
    return 'Login u bllokua nga API key (403). Për lokal: shto http://localhost:8080/* te key-i UdGfU. '
        'Për live: https://kresha325.github.io/*';
  }
  if (text.contains('invalid-credential') ||
      text.contains('invalid-login-credentials') ||
      text.contains('wrong-password')) {
    return 'Email ose fjalëkalim i gabuar.';
  }
  if (text.contains('user-not-found')) {
    return 'Nuk ekziston llogari me këtë email.';
  }
  if (text.contains('operation-not-allowed')) {
    return 'Aktivizo Email/Password në Firebase Authentication.';
  }
  return text.replaceFirst('Exception: ', '');
}
