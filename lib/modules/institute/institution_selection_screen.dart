import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/selection_card.dart';

class InstitutionSelectionScreen extends StatelessWidget {
  const InstitutionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              const Text(
                "Select Institution Type",
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 10),

              const Text(
                "Choose how you want to use Skolr",
                style: AppTextStyles.subheading,
              ),

              const SizedBox(height: 40),

              SelectionCard(
                title: "Coaching Institute",
                subtitle: "Manage batches, fees, attendance and notes",
                icon: Icons.school_rounded,
                onTap: () {},
              ),

              const SizedBox(height: 20),

              SelectionCard(
                title: "School",
                subtitle: "Manage classes, sections and staff",
                icon: Icons.apartment_rounded,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}