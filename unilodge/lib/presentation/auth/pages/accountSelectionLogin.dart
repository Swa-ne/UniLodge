import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/auth/widgets/authButton.dart';
import 'package:unilodge/presentation/auth/widgets/unilodgeText.dart';

class AccountSelectionLogin extends StatelessWidget {
  const AccountSelectionLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: screenHeight * 0.14),
              UnilodgeText(),
              SizedBox(
                height: screenHeight * 0.08,
              ),
              const Text(
                'Log in',
                style: TextStyle(
                  color: AppColors.formTextColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.06,
              ),
              Column(
                children: [
                  AuthButton(
                    text: 'Use email or username',
                    onPressed: () {
                      context.push("/login");
                    },
                    icon: const Icon(Icons.person,
                        size: 25, color: Color.fromARGB(255, 53, 68, 80)),
                  ),
                  const SizedBox(height: 5),
                  AuthButton(
                    text: 'Continue with Facebook',
                    onPressed: () {
                      context.go('/'); // TODO: add facebook
                    },
                    icon: const Icon(Icons.facebook,
                        size: 25, color: Color.fromARGB(255, 53, 68, 80)),
                  ),
                  const SizedBox(height: 5),
                  AuthButton(
                    text: 'Continue with Google',
                    onPressed: () {
                      context.go('/'); // TODO: add google
                    },
                    icon: Image.asset('assets/images/google_logo.png',
                        width: 22,
                        height: 22,
                        color: Color.fromARGB(255, 53, 68, 80)),
                  ),
                  SizedBox(height: screenHeight * 0.2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.formTextColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.go('/account-selection-signup');
                        },
                        child: const Text(
                          "Sign up",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
