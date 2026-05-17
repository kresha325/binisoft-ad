/// Bootstrap superadmin emails (registration only). Remove or change later in this file.
class SuperAdminConfig {
  SuperAdminConfig._();

  static const bootstrapEmails = <String>{
    'kreshnik.sh.gashi@hotmail.com',
  };

  static bool isBootstrapEmail(String email) =>
      bootstrapEmails.contains(email.trim().toLowerCase());
}
