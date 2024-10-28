import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/authentication/auth_bloc.dart';
import 'package:unilodge/bloc/authentication/auth_event.dart';
import 'package:unilodge/bloc/authentication/auth_state.dart';
import 'package:unilodge/common/widgets/custom_button.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/screens/auth/change_forgotten_password.dart';

class VerifyEmail extends StatefulWidget {
  final String email_address;
  final String token;
  final bool isEmailVerification;

  const VerifyEmail(
      {super.key,
      required this.email_address,
      required this.token,
      this.isEmailVerification = true});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  late AuthBloc _authBloc;
  final TextEditingController code1Controller = TextEditingController();
  final TextEditingController code2Controller = TextEditingController();
  final TextEditingController code3Controller = TextEditingController();
  final TextEditingController code4Controller = TextEditingController();
  final TextEditingController code5Controller = TextEditingController();
  final TextEditingController code6Controller = TextEditingController();

  Timer? _timer;
  int _countdown = 60; // 1 minutes countdown
  bool _isResendButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    startTimer();
  }

  void startTimer() {
    setState(() => _isResendButtonDisabled = true);
    _countdown = 60; // reset to 1 minutes
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _isResendButtonDisabled = false;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ResendEmailCodeSuccess) {
          if (state.isSuccess) {
            startTimer();
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No internet connection'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is VerifyEmailSuccess) {
          if (widget.isEmailVerification) {
            context.go("/home");
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeForgottenPassword(
                token: state.token,
              ),
            ),
          );
        } else if (state is VerificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(
            text: "Verify Your Email",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        // backgroundColor: const Color(0xffF2F2F2),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  'assets/images/icons/email.png',
                  height: 240,
                ),
                const SizedBox(height: 30),
                // Text(
                //   widget.isEmailVerification
                //       ? 'Email Verification'
                //       : 'Forget Password',
                //   style: const TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // const SizedBox(height: 8),
                CustomText(
                  text: 'Enter the code sent to ${widget.email_address}',
                  fontSize: 16,
                  color: AppColors.primary,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 20),
                Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var controller in [
                        code1Controller,
                        code2Controller,
                        code3Controller,
                        code4Controller,
                        code5Controller,
                        code6Controller,
                      ])
                        SizedBox(
                          height: 58,
                          width: 54,
                          child: TextField(
                            controller: controller,
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isResendButtonDisabled
                          ? null
                          : () {
                              _authBloc.add(ResendEmailCodeEvent(widget.token));
                            },
                      child: Text(
                        _isResendButtonDisabled
                            ? 'Resend Code ($_countdown s)'
                            : 'Resend Code',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isResendButtonDisabled
                              ? Colors.grey
                              : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "Verify",
                  onPressed: () {
                    String verificationCode = [
                      code1Controller.text.trim(),
                      code2Controller.text.trim(),
                      code3Controller.text.trim(),
                      code4Controller.text.trim(),
                      code5Controller.text.trim(),
                      code6Controller.text.trim()
                    ].join();

                    if (verificationCode.length != 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please enter a valid 6-digit verification code.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      _authBloc.add(
                          VerifyEmailEvent(widget.token, verificationCode));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
