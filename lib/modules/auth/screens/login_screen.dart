import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              Text(
                "Welcome to Skolr",
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 10),

              Text(
                "Manage your institute easily",
                style: AppTextStyles.subheading,
              ),

              const SizedBox(height: 40),

              const CustomTextField(
                hintText: "Phone Number",
              ),

              const SizedBox(height: 20),

              const CustomTextField(
                hintText: "Password",
                obscureText: true,
              ),

              const SizedBox(height: 30),

              PrimaryButton(
                text: "Login",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}