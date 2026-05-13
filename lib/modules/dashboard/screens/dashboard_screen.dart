import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/widgets/skolr_bottom_nav.dart';
import 'attendance_page.dart';
import 'fees_page.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'students_page.dart';

// ---------------------------------------------------------------------------
// DashboardScreen — root after sign-in.
//
// Uses the v2 SkolrBottomNav with an animated pill indicator and
// frosted glass background when content scrolls beneath it.
//
// Pages are kept alive via IndexedStack so tab-switches don't lose
// scroll position or rebuild expensive widgets.
// ---------------------------------------------------------------------------

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    StudentsPage(),
    AttendancePage(),
    FeesPage(),
  ];

  static const _items = [
    SkolrNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    SkolrNavItem(
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_alt_rounded,
      label: 'Students',
    ),
    SkolrNavItem(
      icon: Icons.check_circle_outline_rounded,
      activeIcon: Icons.check_circle_rounded,
      label: 'Attendance',
    ),
    SkolrNavItem(
      icon: Icons.currency_rupee_rounded,
      activeIcon: Icons.currency_rupee_rounded,
      label: 'Fees',
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SkolrBottomNav(
        currentIndex: _currentIndex,
        items: _items,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}