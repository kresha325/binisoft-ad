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
    case 'invalid-api-key':
    case 'api-key-not-valid':
      return 'API key i Firebase është i kufizuar. Në Google Cloud Console → Credentials → '
          'Browser key, shto HTTP referrers: localhost/* dhe '
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
  if (text.contains('API key not valid') ||
      text.contains('API_KEY_INVALID') ||
      text.contains('API_KEY_HTTP_REFERRER_BLOCKED') ||
      (text.contains('identitytoolkit') &&
          (text.contains('400') || text.contains('403')))) {
    return 'Login u bllokua nga API key (403). Hap dashboard vetëm nga '
        'https://kresha325.github.io/binisoft-ad/app/ — në Google Cloud shto referrer '
        'https://kresha325.github.io/* dhe në Firebase Auth domain kresha325.github.io.';
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
