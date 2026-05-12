import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/dashboard_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 10),

              const Text(
                "Welcome Back 👋",
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 8),

              const Text(
                "Here's what's happening today",
                style: AppTextStyles.subheading,
              ),

              const SizedBox(height: 30),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: const [
                    DashboardCard(
                      title: "Students",
                      value: "1,248",
                      icon: Icons.people_rounded,
                    ),

                    DashboardCard(
                      title: "Attendance",
                      value: "92%",
                      icon: Icons.check_circle_rounded,
                    ),

                    DashboardCard(
                      title: "Pending Fees",
                      value: "₹48K",
                      icon: Icons.currency_rupee_rounded,
                    ),

                    DashboardCard(
                      title: "Teachers",
                      value: "24",
                      icon: Icons.school_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}