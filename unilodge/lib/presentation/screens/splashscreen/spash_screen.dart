import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/authentication/auth_bloc.dart';
import 'package:unilodge/bloc/authentication/auth_event.dart';
import 'package:unilodge/bloc/authentication/auth_state.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        BlocProvider.of<AuthBloc>(context).add(AuthenticateTokenEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go('/home'); 
        } else if (state is AuthFailure) {
          context.go('/onboarding'); 
        }
      },
      child: AnimatedSplashScreen(
        splash: Center(
          child: Lottie.asset('assets/animation/animation.json'), // TODO: change to logo asset, remove animatedsplash
        ),
        splashIconSize: 250, 
        duration: 3500,
        splashTransition:
            SplashTransition.fadeTransition,
        backgroundColor: Colors.white, 
        nextScreen:
            Container(),
      ),
    );
  }
}
