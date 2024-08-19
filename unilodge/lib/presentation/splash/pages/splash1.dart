import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/core/configs/theme/app_theme.dart';

class SplashPage1 extends StatefulWidget {
  const SplashPage1({super.key});

  @override
  State<SplashPage1> createState() => _SplashPage1State();
}

class _SplashPage1State extends State<SplashPage1> {
  @override
  void initState() {
    super.initState();
  }

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
              Image.asset(
                AppImages.logo,
                width: 190,
              ),
              Text(
                'UniLodge',
                style: TextStyle(
                    fontFamily: AppTheme.logoFont,
                    fontSize: 36,
                    color: AppColors.lightBlueTextColor),
              ),
              SizedBox(
                height: 280,
              ),
              SizedBox(
                width: 270,
                height: 50,
                child: OutlinedButton(
                    onPressed: () async {
                      context.go('/splash2');
                    },
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white)),
                    child: Text(
                      'Next',
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
