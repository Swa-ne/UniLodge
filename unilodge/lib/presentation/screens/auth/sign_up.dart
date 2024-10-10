import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with InputValidationMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  DateTime? _birthday;
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late AuthBloc _authBloc;

  String? emailError;
  String? firstNameError;
  String? lastNameError;
  String? passwordError;
  String? usernameError;
  String? birthdayError;
  String? confirmPasswordError;
  String? phoneNumberError;
  bool isPhoneNumberValid = false;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    emailController = TextEditingController();
    firstNameController = TextEditingController();
    middleNameController = TextEditingController();
    lastNameController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
      setState(() {
        _currentPage--;
      });
    }
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          context.go("/verify-email", extra: {
            "email_address": obfuscateEmail(emailController.text),
            "token": state.token,
          });
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
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          children: [
                            _buildPersonalInfoPage(context, screenHeight),
                            _buildAccountInfoPage(context, screenHeight),
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
                    onPressed: () => {
                      if (_currentPage == 0)
                        {context.go("/account-selection-signup")}
                      else
                        {_previousPage()}
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

  Widget _buildPersonalInfoPage(BuildContext context, double screenHeight) {
    return Form(
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          AuthTextField(
            labelText: "Email *",
            hintText: "Enter email",
            controller: emailController,
            onChanged: validateEmailInUse,
            errorText: emailError,
          ),
          const SizedBox(height: 20.0),
          AuthTextField(
            labelText: "First Name *",
            hintText: "Enter first name",
            controller: firstNameController,
            onChanged: validateName,
            errorText: firstNameError,
          ),
          const SizedBox(height: 20.0),
          AuthTextField(
            labelText: "Middle Name",
            hintText: "Enter middle name",
            controller: middleNameController,
          ),
          const SizedBox(height: 20.0),
          AuthTextField(
            labelText: "Last Name *",
            hintText: "Enter last name",
            controller: lastNameController,
            onChanged: validateName,
            errorText: lastNameError,
          ),
          const SizedBox(height: 20.0),
          SizedBox(height: screenHeight * 0.10),
          _buildPageIndicator(),
          const SizedBox(height: 20.0),
          CustomButton(
            text: "Next",
            onPressed: () async {
              String? isValidEmail =
                  await validateEmailInUse(emailController.text);
              if (isValidEmail != null) {
                setState(() {
                  emailError = isValidEmail;
                });
                return;
              }
              String? isNameValid = validateName(firstNameController.text);
              if (isNameValid != null) {
                setState(() {
                  firstNameError = isNameValid;
                });
                return;
              }
              isNameValid = validateName(lastNameController.text);
              if (isNameValid != null) {
                setState(() {
                  lastNameError = isNameValid;
                });
                return;
              }
              if (!isPhoneNumberValid) {
                setState(() {
                  phoneNumberError = "This field cannot be empty";
                });
                return;
              }
              _nextPage();
            },
          ),
          const SizedBox(height: 10),
          _buildLoginText(context),
        ],
      ),
    );
  }

  Widget _buildAccountInfoPage(BuildContext context, double screenHeight) {
    return Form(
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          AuthTextField(
            labelText: "Username *",
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
                labelText: _birthday != null ? "Birthdate" : null,
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
          AuthTextField(
            labelText: "Password *",
            hintText: "Enter password",
            obscureText: true,
            controller: passwordController,
            onChanged: validatePassword,
            errorText: passwordError,
          ),
          const SizedBox(height: 20.0),
          AuthTextField(
            labelText: "Confirm Password *",
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
          SizedBox(height: screenHeight * 0.17),
          _buildPageIndicator(),
          const SizedBox(height: 20.0),
          CustomButton(
            text: "Sign Up",
            onPressed: () async {
              String? isValidUsername =
                  await validateUsernameInUse(usernameController.text);
              if (isValidUsername != null) {
                setState(() {
                  usernameError = isValidUsername;
                });
                return;
              }
              if (_birthday == null) {
                setState(() {
                  birthdayError = "Please choose your birthday";
                });
                return;
              }
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
              final newUser = SignUpUserModel(
                first_name: firstNameController.text,
                middle_name: middleNameController.text,
                last_name: lastNameController.text,
                username: usernameController.text,
                email: emailController.text,
                password_hash: passwordController.text,
                confirmation_password: confirmPasswordController.text,
                personal_number: "",
                birthday: _birthday.toString(),
              );
              _authBloc.add(SignUpEvent(newUser));
            },
          ),
          const SizedBox(height: 10),
          _buildLoginText(context),
        ],
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

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(0),
        const SizedBox(width: 8),
        _buildDot(1),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? AppColors.primary : Colors.grey.shade300,
      ),
    );
  }
}
