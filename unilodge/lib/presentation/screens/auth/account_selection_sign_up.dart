import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/sources/auth/auth_firebase_repo.dart';
import 'package:unilodge/presentation/screens/auth/third_party_sign_up.dart';
import 'package:unilodge/presentation/widgets/auth/auth_button.dart';
import 'package:unilodge/presentation/widgets/auth/unilodge_text.dart';

class AccountSelectionSignup extends StatefulWidget {
  const AccountSelectionSignup({super.key});

  @override
  State<AccountSelectionSignup> createState() => _AccountSelectionSignupState();
}

class _AccountSelectionSignupState extends State<AccountSelectionSignup> {
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
              const UnilodgeText(),
              SizedBox(
                height: screenHeight * 0.08,
              ),
              const Text(
                'Sign up',
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
                    text: 'Use Email Address',
                    onPressed: () {
                      context.push("/sign-up");
                    },
                    icon: const Icon(
                      Icons.person,
                      size: 25,
                      color: Color.fromARGB(255, 53, 68, 80),
                    ),
                  ),
                  const SizedBox(height: 5),
                  AuthButton(
                    text: 'Continue with Google',
                    onPressed: () async {
                      var google_user =
                          await AuthFirebaseRepoImpl().signUpWithGoogle();
                      if (mounted) {
                        if (google_user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThirdPartySignUp(
                                google_user: google_user,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('The email address is already used.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No internet connection'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: Image.asset('assets/images/google_logo.png',
                        width: 22,
                        height: 22,
                        color: const Color.fromARGB(255, 53, 68, 80)),
                  ),
                  SizedBox(height: screenHeight * 0.2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.formTextColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.go('/account-selection-login');
                        },
                        child: const Text(
                          "Log in",
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
