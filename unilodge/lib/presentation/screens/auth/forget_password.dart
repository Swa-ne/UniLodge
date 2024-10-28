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
import 'package:unilodge/presentation/screens/auth/verify_email.dart';
import 'package:unilodge/presentation/widgets/auth/auth_text_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with InputValidationMixin {
  final TextEditingController emailController = TextEditingController();
  String? emailError;
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyEmail(
                email_address: obfuscateEmail(emailController.text),
                token: state.token,
                isEmailVerification: false,
              ),
            ),
          );
        } else if (state is ForgetPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
        title: const CustomText(
          text: "Forgot Password",
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.push("/login");
          },
        ),
      ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [              
              const SizedBox(height: 60),
              Image.asset(
                'assets/images/icons/mobile-password-forgot.png',
                height: 240,
              ),
              const SizedBox(height: 30),
              const Center(
                child: SizedBox(
                  width: 220,
                  child: CustomText(
                    text:
                        "Please enter your email address to receive a verification code.",
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    color: AppColors.primary
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: AuthTextField(
                          labelText: "Email",
                          hintText: "Enter email",
                          controller: emailController,
                          onChanged: validateEmail,
                          errorText: emailError,
                        ),
                      ),
                      const SizedBox(height: 25),
                      CustomButton(
                          text: "Send",
                          onPressed: () {
                            String? isValidEmail =
                                validateEmail(emailController.text);
                            if (isValidEmail != null) {
                              setState(() {
                                emailError = isValidEmail;
                              });
                              return;
                            }

                            authBloc
                                .add(ForgotPasswordEvent(emailController.text));
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
