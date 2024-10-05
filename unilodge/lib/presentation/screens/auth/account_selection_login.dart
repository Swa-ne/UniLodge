import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/login_user.dart';
import 'package:unilodge/data/sources/auth/auth_firebase_repo.dart';
import 'package:unilodge/bloc/authentication/auth_bloc.dart';
import 'package:unilodge/bloc/authentication/auth_event.dart';
import 'package:unilodge/bloc/authentication/auth_state.dart';
import 'package:unilodge/presentation/widgets/auth/auth_button.dart';
import 'package:unilodge/presentation/widgets/auth/unilodge_text.dart';

final _secretKey = dotenv.env['SECRET_KEY'];

class AccountSelectionLogin extends StatefulWidget {
  const AccountSelectionLogin({super.key});

  @override
  State<AccountSelectionLogin> createState() => _AccountSelectionLoginState();
}

class _AccountSelectionLoginState extends State<AccountSelectionLogin> {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.go("/home");
        } else if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
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
                      text: 'Use Email Address',
                      onPressed: () {
                        context.push("/login");
                      },
                      icon: const Icon(Icons.person,
                          size: 25, color: Color.fromARGB(255, 53, 68, 80)),
                    ),
                    const SizedBox(height: 5),
                    AuthButton(
                      text: 'Continue with Google',
                      onPressed: () async {
                        var google_user =
                            await AuthFirebaseRepoImpl().loginWithGoogle();
                        if (mounted) {
                          if (google_user != null) {
                            final newUser = LoginUserModel(
                              email: google_user.email,
                              password: "$_secretKey${google_user.id}",
                            );
                            authBloc.add(LoginEvent(newUser));
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
      ),
    );
  }
}
