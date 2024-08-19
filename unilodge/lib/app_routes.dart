import 'package:go_router/go_router.dart';
import 'package:unilodge/presentation/auth/pages/login.dart';
import 'package:unilodge/presentation/auth/pages/signIn.dart';
import 'package:unilodge/presentation/splash/pages/splash1.dart';
import 'package:unilodge/presentation/splash/pages/splash2.dart';
import 'package:unilodge/presentation/splash/pages/splash3.dart';

final GoRouter appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashPage1(),
  ),
  GoRoute(
    path: '/splash2',
    builder: (context, state) => const SplashPage2(),
  ),
  GoRoute(
    path: '/splash3',
    builder: (context, state) => const SplashPage3(),
  ),
  GoRoute(
    path: '/signin',
    builder: (context, state) => const Signin(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const Login(),
  ),
]);
