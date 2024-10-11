import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/authentication/auth_bloc.dart';
import 'package:unilodge/bloc/authentication/auth_event.dart';
import 'package:unilodge/bloc/authentication/auth_state.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/screens/auth/change_forgotten_password.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ResendEmailCodeSuccess) {
          if (state.isSuccess) {
            // TODO: add timer 3 minutes timer before resend button can be available again
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
            icon: const Icon(Icons.arrow_back_ios),
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
                      SizedBox(
                        height: 58,
                        width: 54,
                        child: TextField(
                          controller: code1Controller,
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
                      SizedBox(
                        height: 58,
                        width: 54,
                        child: TextField(
                          controller: code2Controller,
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
                      SizedBox(
                        height: 58,
                        width: 54,
                        child: TextField(
                          controller: code3Controller,
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
                      SizedBox(
                        height: 58,
                        width: 54,
                        child: TextField(
                          controller: code4Controller,
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
                      SizedBox(
                        height: 58,
                        width: 54,
                        child: TextField(
                          controller: code5Controller,
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
                      SizedBox(
                        height: 58,
                        width: 54,
                        child: TextField(
                          controller: code6Controller,
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
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 11)),
                      onPressed: () {
                        _authBloc.add(ResendEmailCodeEvent(widget.token));
                        // TODO: disable this button temporarily and enable after the timer runs out
                      },
                      child: const Text(
                        'Resend Code',
                        style: TextStyle(color: Color(0xFF51DAF6)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 300,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      String code1 = code1Controller.text.trim();
                      String code2 = code2Controller.text.trim();
                      String code3 = code3Controller.text.trim();
                      String code4 = code4Controller.text.trim();
                      String code5 = code5Controller.text.trim();
                      String code6 = code6Controller.text.trim();

                      String verification_code =
                          "$code1$code2$code3$code4$code5$code6";

                      if (verification_code.length != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please enter a valid 6-digit verification code.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        _authBloc.add(
                            VerifyEmailEvent(widget.token, verification_code));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E3E4A),
                    ),
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
