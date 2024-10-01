import 'package:dlibphonenumber/phone_number_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:unilodge/common/widgets/custom_button.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:unilodge/presentation/widgets/auth_widgets/unilodge_text.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  DateTime? _selectedDate;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'PH');
  PhoneNumberUtil phoneUtil = PhoneNumberUtil.instance;

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
      initialDate: _selectedDate ??
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
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
          _buildTextField("Email", "Enter email"),
          const SizedBox(height: 20.0),
          _buildTextField("First Name", "Enter first name"),
          const SizedBox(height: 20.0),
          _buildTextField("Middle Name", "Enter middle name"),
          const SizedBox(height: 20.0),
          _buildTextField("Last Name", "Enter last name"),
          const SizedBox(height: 20.0),
          _buildPhoneNumberField(),
          SizedBox(height: screenHeight * 0.10),
          _buildPageIndicator(),
          const SizedBox(height: 20.0),
          CustomButton(text: "Next", onPressed: _nextPage),
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
          _buildTextField("Username", "Enter username"),
          const SizedBox(height: 20.0),
          InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: _selectedDate != null ? "Birthdate" : null,
                filled: true,
                fillColor: AppColors.blueTextColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
              ),
              child: Text(
                _selectedDate == null
                    ? 'Select birthdate'
                    : DateFormat.yMMMd().format(_selectedDate!),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.formTextColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          _buildTextField("Password", "Enter password", obscureText: true),
          const SizedBox(height: 20.0),
          _buildTextField("Confirm Password", "Enter confirm password",
              obscureText: true),
          SizedBox(height: screenHeight * 0.17),
          _buildPageIndicator(),
          const SizedBox(height: 20.0),
          CustomButton(
              text: "Sign Up",
              onPressed: () {
                context.go('/home');
              }),
          const SizedBox(height: 10),
          _buildLoginText(context),
          TextButton(
            onPressed: _previousPage,
            child: const Text(
              'Back',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String labelText, String hintText,
      {bool obscureText = false}) {
    return TextField(
      keyboardType:
          obscureText ? TextInputType.visiblePassword : TextInputType.text,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.blueTextColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(
          color: AppColors.formTextColor,
          height: 1.3,
        ),
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        _phoneNumber = number;
        print('Phone number: ${number.phoneNumber}');
        bool isValid = phoneUtil
            .isValidNumber(phoneUtil.parse(number.phoneNumber, number.isoCode));
        print('is it valid: $isValid');
      },
      onInputValidated: (bool isValid) {},
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _phoneNumber,
      formatInput: true,
      keyboardType: TextInputType.phone,
      inputDecoration: InputDecoration(
        filled: true,
        fillColor: AppColors.blueTextColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        labelText: 'Phone Number',
        hintText: 'eg. 9123000000',
        labelStyle: const TextStyle(
          color: AppColors.formTextColor,
          height: 1.3,
        ),
        hintStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
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
