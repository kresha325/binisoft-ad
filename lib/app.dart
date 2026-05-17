import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:business_dashboard/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/branding.dart';
import 'core/l10n/app_locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'core/widgets/splash_screen.dart';

class BusinessDashboardApp extends ConsumerStatefulWidget {
  const BusinessDashboardApp({super.key});

  @override
  ConsumerState<BusinessDashboardApp> createState() => _BusinessDashboardAppState();
}

class _BusinessDashboardAppState extends ConsumerState<BusinessDashboardApp> {
  bool _splashDone = false;

  @override
  void initState() {
    super.initState();
    // Brief in-app splash on web so HTML boot can hide after real UI (not a white frame).
    if (kIsWeb) {
      Future<void>.delayed(const Duration(milliseconds: 400), () {
        if (mounted) setState(() => _splashDone = true);
      });
      return;
    }
    Future<void>.delayed(AppBranding.splashDuration, () {
      if (mounted) setState(() => _splashDone = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = resolveThemeMode(ref.watch(themeModeProvider));
    final locale = resolveAppLocale(ref.watch(appLocaleProvider));

    final localizations = [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

    if (!_splashDone) {
      return MaterialApp(
        title: AppBranding.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        locale: locale,
        localizationsDelegates: localizations,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SplashScreen(),
      );
    }

    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: AppBranding.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: localizations,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
