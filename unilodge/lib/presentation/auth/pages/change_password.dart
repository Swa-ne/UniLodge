import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/common/widgets/customButton.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/auth/bloc/auth_bloc.dart';
import 'package:unilodge/presentation/auth/bloc/auth_event.dart';
import 'package:unilodge/presentation/auth/bloc/auth_state.dart';
import 'package:unilodge/presentation/auth/mixin/input_validation.dart';
import 'package:unilodge/presentation/auth/widgets/authTextField.dart';

class ChangePassword extends StatefulWidget {
  final String token;
  const ChangePassword({super.key, required this.token});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with InputValidationMixin {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late AuthBloc _authBloc;

  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          context.go("/login");
        } else if (state is ChangePasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Change Password',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AuthTextField(
                        labelText: "Password",
                        hintText: "Enter password",
                        obscureText: true,
                        controller: passwordController,
                        onChanged: validatePassword,
                        errorText: passwordError,
                      ),
                      const SizedBox(height: 20.0),
                      AuthTextField(
                        labelText: "Confirm Password",
                        hintText: "Enter confirm password",
                        obscureText: true,
                        controller: confirmPasswordController,
                        onChanged: (confirmPasswordText) {
                          return validateConfirmPassword(
                            passwordController.text,
                            confirmPasswordText,
                          );
                        },
                        errorText: confirmPasswordError,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                          text: "Send",
                          onPressed: () {
                            // TODO: go to login page then change the password
                            String? isPasswordValid =
                                validatePassword(passwordController.text);
                            if (isPasswordValid != null) {
                              setState(() {
                                passwordError = isPasswordValid;
                              });
                              return;
                            }
                            isPasswordValid = validateConfirmPassword(
                              confirmPasswordController.text,
                              passwordController.text,
                            );
                            if (isPasswordValid != null) {
                              setState(() {
                                confirmPasswordError = isPasswordValid;
                              });
                              return;
                            }
                            _authBloc.add(PostResetPasswordEvent(
                              widget.token,
                              passwordController.text,
                              confirmPasswordController.text,
                            ));
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
