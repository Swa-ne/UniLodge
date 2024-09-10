import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/core/configs/theme/app_theme.dart';
import 'package:unilodge/presentation/auth/widgets/authButton.dart';

class AccountSelectionLogin extends StatelessWidget {
  const AccountSelectionLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff83a2ac),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            stops: [0.00, 0.18, 0.90],
          ),
        ),
        child: SizedBox(
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
                SizedBox(height: screenHeight * 0.15),
                const Text(
                  'UniLodge',
                  style: TextStyle(
                    fontFamily: AppTheme.logoFont,
                    fontSize: 36,
                    color: AppColors.lightBlueTextColor,
                  ),
                ),
                const Text(
                  'Log in to UniLodge',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 40,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.08,
                ),
                Column(
                  children: [
                    AuthButton(
                      text: 'Use email or username',
                      onPressed: () {
                        context.go('/login');
                      },
                      icon: const Icon(Icons.person),
                    ),
                    const SizedBox(height: 5),
                    AuthButton(
                      text: 'Continue with Facebook',
                      onPressed: () {
                        context.go('/'); // TODO: add facebook
                      },
                      icon: const Icon(Icons.facebook),
                    ),
                    const SizedBox(height: 5),
                    AuthButton(
                      text: 'Continue with Google',
                      onPressed: () {
                        context.go('/'); // TODO: add google
                      },
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        width: 18,
                        height: 18,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.go('/');
                          },
                          child: const Text(
                            "Sign up",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue,
                            ),
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
      ),
    );
  }
}
