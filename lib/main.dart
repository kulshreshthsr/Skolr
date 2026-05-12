import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'modules/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skolr',
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}