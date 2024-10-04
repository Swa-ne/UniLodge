import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/common/widgets/customButton.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/loginUser.dart';
import 'package:unilodge/presentation/auth/bloc/auth_bloc.dart';
import 'package:unilodge/presentation/auth/bloc/auth_event.dart';
import 'package:unilodge/presentation/auth/bloc/auth_state.dart';
import 'package:unilodge/presentation/auth/mixin/input_validation.dart';
import 'package:unilodge/presentation/auth/widgets/authTextField.dart';
import 'package:unilodge/presentation/auth/widgets/unilodgeText.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with InputValidationMixin {
  late AuthBloc _authBloc;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is EmailNotVerified) {
          _authBloc.add(ResendEmailCodeEvent(state.token));
          context.go("/verify-email", extra: {
            "email_address": obfuscateEmail(emailController.text),
            "token": state.token,
          });
        } else if (state is LoginError) {
          // TODO: fix this if it looks ugly hahahaha
          setState(() {
            emailError = "Incorrect Email or Password";
            passwordError = "Incorrect Email or Password";
          });
        }
      },
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            return;
          }
          if (context.mounted) {
            Navigator.pop(context, result);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      const UnilodgeText(),
                      SizedBox(height: screenHeight * 0.10),
                      Form(
                        child: Column(
                          children: [
                            AuthTextField(
                              labelText: "Email",
                              hintText: "Enter email",
                              controller: emailController,
                              onChanged: validateEmail,
                              errorText: emailError,
                            ),
                            const SizedBox(height: 20.0),
                            AuthTextField(
                              labelText: "Password",
                              hintText: "Enter password",
                              obscureText: true,
                              controller: passwordController,
                              errorText: passwordError,
                            ),
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  context.push("/forget-password");
                                },
                                child: const Text(
                                  "Forgot your password?",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 36, 141, 221),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.37),
                            CustomButton(
                                text: "Log in",
                                onPressed: () {
                                  String? isValidEmail =
                                      validateEmail(emailController.text);
                                  if (isValidEmail != null) {
                                    setState(() {
                                      emailError = "Email can't be empty";
                                    });
                                    return;
                                  }
                                  if (passwordController.text.isEmpty) {
                                    setState(() {
                                      passwordError = "Password can't be empty";
                                    });
                                    return;
                                  }
                                  final newUser = LoginUserModel(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  _authBloc.add(LoginEvent(newUser));
                                }),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.formTextColor),
                                ),
                                InkWell(
                                  onTap: () {
                                    context.go("/sign-up");
                                  },
                                  child: const Text(
                                    "Sign up",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16.0,
                  left: 16.0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.go("/account-selection-login");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
