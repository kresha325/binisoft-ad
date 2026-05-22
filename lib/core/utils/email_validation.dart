final _basicEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Normalizes and validates account email for auth flows.
String? validateAccountEmail(String raw) {
  final email = raw.trim().toLowerCase();
  if (email.isEmpty || !_basicEmail.hasMatch(email)) return null;
  return email;
}
