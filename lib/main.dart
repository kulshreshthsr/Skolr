import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/design_system/_preview.dart';
import 'core/design_system/design_system.dart';
import 'core/screens/splash_screen.dart';
import 'core/widgets/_gallery.dart';

// ---------------------------------------------------------------------------
// Skolr — main entry point.
//
// Theme is driven by SkolrThemeController (a global ChangeNotifier).
// The Settings screen will call SkolrThemeController.instance.setMode(...)
// to flip between dark / light / system.
//
// Debug flags below let you bypass splash and jump straight to:
//   • The design system preview
//   • The widget gallery
// Both must be `false` for production builds.
// ---------------------------------------------------------------------------

// Debug flags — flip to true to open the respective review screen.
const bool _kShowDesignPreview = false;
const bool _kShowWidgetGallery = false;

void main() {
  // Edge-to-edge so the gradient background reaches under the status bar
  // and gesture nav area.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    const ProviderScope(
      child: SkolrApp(),
    ),
  );
}

class SkolrApp extends StatelessWidget {
  const SkolrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SkolrThemeController.instance,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Skolr',
          theme: SkolrTheme.light(),
          darkTheme: SkolrTheme.dark(),
          themeMode: SkolrThemeController.instance.mode,
          home: _kShowWidgetGallery
              ? const WidgetGallery()
              : _kShowDesignPreview
                  ? const DesignSystemPreview()
                  : const SplashScreen(),
        );
      },
    );
  }
}