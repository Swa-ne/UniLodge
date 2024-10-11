import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/common/widgets/custom_button.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/bloc/authentication/auth_bloc.dart';
import 'package:unilodge/bloc/authentication/auth_event.dart';
import 'package:unilodge/bloc/authentication/auth_state.dart';
import 'package:unilodge/presentation/auth/mixin/input_validation.dart';
import 'package:unilodge/presentation/widgets/auth/auth_text_field.dart';

class ChangeForgottenPassword extends StatefulWidget {
  final String token;
  const ChangeForgottenPassword({super.key, required this.token});

  @override
  State<ChangeForgottenPassword> createState() =>
      _ChangeForgottenPasswordState();
}

class _ChangeForgottenPasswordState extends State<ChangeForgottenPassword>
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
          context.push("/account-selection-login");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully!')),
          );
        } else if (state is ChangePasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const CustomText(
            text: "Create New Password",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: AppColors.lightBackground,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/icons/security.png',
                        height: 240,
                      ),
                      const SizedBox(height: 30),
                      const Center(
                        child: SizedBox(
                          width: 240,
                          child: CustomText(
                            text:
                                'Your new password must be different from previously used passwords.',
                            fontWeight: FontWeight.w600,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      AuthTextField(
                        labelText: "New Password",
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
                        },
                      ),
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
