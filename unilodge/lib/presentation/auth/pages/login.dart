import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/core/configs/theme/app_theme.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

// nilagay lang

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 174, 189, 201),
              Color(0xff2E3E4A),
            ])),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 180,
              ),
              Text(
                'UniLodge',
                style: TextStyle(
                    fontFamily: AppTheme.logoFont,
                    fontSize: 36,
                    color: AppColors.lightBlueTextColor),
              ),
              Text('Log In Page', style: TextStyle(color: AppColors.textColor)),
              SizedBox(
                height: 450,
              ),
              SizedBox(
                width: 270,
                height: 50,
                child: OutlinedButton(
                    onPressed: () async {
                      context.go('/home');
                    },
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white)),
                    child: Text(
                      'Log In',
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
