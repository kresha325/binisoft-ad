import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/branding.dart';
import '../theme/app_theme.dart';

/// Launch splash shown for [AppBranding.splashDuration].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _precachedLogo = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precachedLogo) {
      _precachedLogo = true;
      precacheImage(
        const AssetImage(AppBranding.logoAssetDark),
        context,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F1A33),
              AppColors.navy,
              Color(0xFF1A3A5C),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _SplashLogo(),
                      const SizedBox(height: 24),
                      Text(
                        AppBranding.splashTagline,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.88),
                          height: 1.45,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.accentTeal.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    const height = 64.0;
    final width = height * AppBranding.logoAspectRatio;

    return Image.asset(
      AppBranding.logoAssetDark,
      height: height,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
      errorBuilder: (_, error, __) {
        debugPrint('Splash logo failed to load: $error');
        return Text(
          'BINISOFT',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1,
          ),
        );
      },
    );
  }
}
