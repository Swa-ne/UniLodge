import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unilodge/common/widgets/custom_button.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:unilodge/data/models/sign_up_user.dart';
import 'package:unilodge/bloc/authentication/auth_bloc.dart';
import 'package:unilodge/bloc/authentication/auth_event.dart';
import 'package:unilodge/bloc/authentication/auth_state.dart';
import 'package:unilodge/presentation/auth/mixin/input_validation.dart';
import 'package:unilodge/presentation/widgets/auth/auth_text_field.dart';
import 'package:unilodge/presentation/widgets/auth/unilodge_text.dart';

final _secretKey = dotenv.env['SECRET_KEY'];

class ThirdPartySignUp extends StatefulWidget {
  final GoogleSignInAccount google_user;

  const ThirdPartySignUp({super.key, required this.google_user});

  @override
  State<ThirdPartySignUp> createState() => _SignUpState();
}

class _SignUpState extends State<ThirdPartySignUp> with InputValidationMixin {
  DateTime? _birthday;
  late TextEditingController fullnameController;
  late TextEditingController usernameController;

  late GoogleSignInAccount _google_user;

  String? fullNameError;
  String? usernameError;
  String? birthdayError;

  @override
  void initState() {
    super.initState();
    fullnameController =
        TextEditingController(text: widget.google_user.displayName);
    usernameController = TextEditingController();
    _google_user = widget.google_user;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday ??
          DateTime(
            now.year - 18,
            now.month,
            now.day,
          ),
      firstDate: DateTime(1900),
      lastDate: DateTime(
        now.year - 18,
        now.month,
        now.day,
      ),
    );
    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
        birthdayError = null;
      });
    } else {
      setState(() {
        birthdayError = "Please choose your birthday";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          context.go("/home");
        } else if (state is SignUpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
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
                      SizedBox(height: screenHeight * 0.05),
                      Form(
                        child: Column(
                          children: [
                            const SizedBox(height: 20.0),
                            AuthTextField(
                              labelText: "Full Name",
                              hintText: "Enter full name",
                              controller: fullnameController,
                              onChanged: validateName,
                              errorText: fullNameError,
                            ),
                            const SizedBox(height: 20.0),
                            AuthTextField(
                              labelText: "Username",
                              hintText: "Enter username",
                              controller: usernameController,
                              onChanged: validateUsernameInUse,
                              errorText: usernameError,
                            ),
                            const SizedBox(height: 20.0),
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText:
                                      _birthday != null ? "Birthdate" : null,
                                  filled: true,
                                  fillColor: AppColors.blueTextColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                      width: 1.5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 16.0,
                                  ),
                                  errorText: birthdayError,
                                  errorStyle: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.redAccent,
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.redAccent,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  _birthday == null
                                      ? 'Select birthdate *'
                                      : DateFormat.yMMMd().format(_birthday!),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.formTextColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            SizedBox(height: screenHeight * 0.17),
                            const SizedBox(height: 20.0),
                            CustomButton(
                              text: "Sign Up",
                              onPressed: () async {
                                String? isNameValid =
                                    validateName(fullnameController.text);
                                if (isNameValid != null) {
                                  setState(() {
                                    fullNameError = isNameValid;
                                  });
                                  return;
                                }
                                String? isValidUsername =
                                    await validateUsernameInUse(
                                        usernameController.text);
                                if (isValidUsername != null) {
                                  setState(() {
                                    usernameError = isValidUsername;
                                  });
                                  return;
                                }
                                if (_birthday == null) {
                                  setState(() {
                                    birthdayError =
                                        "Please choose your birthday";
                                  });
                                  return;
                                }
                                final newUser = SignUpUserModel(
                                    first_name: fullnameController.text,
                                    last_name: " ",
                                    username: usernameController.text,
                                    email: _google_user.email,
                                    password_hash:
                                        "$_secretKey${_google_user.id}",
                                    confirmation_password:
                                        "$_secretKey${_google_user.id}",
                                    personal_number: "",
                                    birthday: _birthday.toString(),
                                    valid_email: true);
                                authBloc.add(SignUpEvent(newUser, true));
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildLoginText(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(fontSize: 14, color: AppColors.formTextColor),
        ),
        InkWell(
          onTap: () {
            context.go("/login");
          },
          child: const Text(
            "Log in",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
