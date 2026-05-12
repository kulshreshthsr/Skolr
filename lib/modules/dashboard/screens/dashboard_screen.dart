import 'package:flutter/material.dart';

import 'attendance_page.dart';
import 'fees_page.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'students_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const StudentsPage(),
    const AttendancePage(),
    const FeesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: "Students",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_rounded),
            label: "Attendance",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.currency_rupee_rounded),
            label: "Fees",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}