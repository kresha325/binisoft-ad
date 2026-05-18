import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:business_dashboard/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/branding.dart';
import 'core/l10n/app_locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_scroll_behavior.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'core/utils/web_boot_overlay.dart';
import 'core/widgets/splash_screen.dart';
import 'core/widgets/web_auth_resolving_gate.dart';

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
    // Web: skip second splash — HTML boot already shown; show landing/login faster on mobile.
    if (kIsWeb) {
      _splashDone = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) dismissWebBootOverlay();
        });
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
        scrollBehavior: AppScrollBehavior(),
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
      scrollBehavior: AppScrollBehavior(),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: localizations,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: kIsWeb
          ? (context, child) => WebAuthResolvingGate(
                child: child ?? const SizedBox.shrink(),
              )
          : null,
    );
  }
}
