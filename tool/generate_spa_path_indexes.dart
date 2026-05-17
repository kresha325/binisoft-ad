import 'dart:io';

/// Copies [build/web/index.html] into route folders so GitHub Pages returns 200
/// for deep links like /binisoft-ad/dashboard (not only 404.html + redirect).
void main() {
  const routes = <String>[
    '/',
    '/login',
    '/register',
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

  final index = File('build/web/index.html');
  if (!index.existsSync()) {
    stderr.writeln('Missing build/web/index.html — run flutter build web first.');
    exit(1);
  }
  final html = index.readAsStringSync();

  for (final route in routes) {
    if (route == '/') continue;
    final dirPath = 'build/web${route.startsWith('/') ? route : '/$route'}';
    final dir = Directory(dirPath);
    dir.createSync(recursive: true);
    File('$dirPath/index.html').writeAsStringSync(html);
    stdout.writeln('Wrote $dirPath/index.html');
  }

  stdout.writeln('SPA path indexes ready (${routes.length - 1} routes).');
}
