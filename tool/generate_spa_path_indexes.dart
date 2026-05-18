import 'dart:io';

/// Copies Flutter [index.html] under [appDir] for deep links, and writes lightweight
/// redirects at the site root for legacy paths like /binisoft-ad/login → /app/#/login.
void main() {
  const appDir = 'build/web/app';
  const routes = <String>[
    '/',
    '/login',
    '/register',
    '/join',
    '/dashboard',
    '/orders',
    '/reports',
    '/businesses',
    '/products',
    '/categories',
    '/offers',
    '/custom-fields',
    '/api-docs',
    '/settings',
    '/billing',
    '/superadmin',
    '/superadmin/invoices',
    '/superadmin/reports',
  ];

  final index = File('$appDir/index.html');
  if (!index.existsSync()) {
    stderr.writeln('Missing $appDir/index.html — run flutter build web -o build/web/app first.');
    exit(1);
  }
  final html = index.readAsStringSync();

  for (final route in routes) {
    if (route == '/') continue;
    final appPath = '$appDir${route.startsWith('/') ? route : '/$route'}';
    final dir = Directory(appPath);
    dir.createSync(recursive: true);
    File('$appPath/index.html').writeAsStringSync(html);
    stdout.writeln('Wrote $appPath/index.html');
  }

  for (final route in routes) {
    if (route == '/') continue;
    final hash = route.startsWith('/') ? route : '/$route';
    final legacyPath = 'build/web${hash.startsWith('/') ? hash : '/$hash'}';
    final dir = Directory(legacyPath);
    dir.createSync(recursive: true);
    File('$legacyPath/index.html').writeAsStringSync(_legacyRedirect(hash));
    stdout.writeln('Wrote legacy redirect $legacyPath/index.html');
  }

  stdout.writeln('SPA indexes ready (${routes.length - 1} app routes + legacy redirects).');
}

String _legacyRedirect(String hashRoute) {
  final target = '../app/#$hashRoute';
  return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0;url=$target">
  <script>location.replace("$target");</script>
  <title>Redirecting…</title>
</head>
<body><p><a href="$target">Continue to Binisoft Admin</a></p></body>
</html>
''';
}
