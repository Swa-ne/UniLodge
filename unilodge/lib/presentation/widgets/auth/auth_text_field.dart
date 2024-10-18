import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class AuthTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final dynamic Function(String)? onChanged;
  final String? errorText;
  final Widget? suffixIcon; 

  const AuthTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.errorText,
    this.suffixIcon, 
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  String? errorText;
  Timer? _debounce;

  final Duration debounceDuration = const Duration(milliseconds: 1250);

  @override
  void initState() {
    super.initState();
    errorText = widget.errorText;
  }

  @override
  void didUpdateWidget(covariant AuthTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != oldWidget.errorText) {
      setState(() {
        errorText = widget.errorText;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.obscureText
          ? TextInputType.visiblePassword
          : TextInputType.text,
      obscureText: widget.obscureText,
      onChanged: (text) {
        if (widget.onChanged != null) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(debounceDuration, () async {
            String? validationError = await widget.onChanged!(text);
            setState(() {
              errorText = validationError;
            });
          });
        }
      },
      decoration: InputDecoration(
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2.0,
          ),
        ),
        errorText: errorText,
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
        labelStyle: const TextStyle(
          color: AppColors.formTextColor,
          height: 1.3,
        ),
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 16.0,
        ),
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
