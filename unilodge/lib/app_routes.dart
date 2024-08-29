import 'package:go_router/go_router.dart';
import 'package:unilodge/presentation/auth/pages/login.dart';
import 'package:unilodge/presentation/auth/pages/signUp.dart';
import 'package:unilodge/presentation/home/pages/dormInformation.dart';
import 'package:unilodge/presentation/home/pages/home.dart';
import 'package:unilodge/presentation/profile/pages/userProfile.dart';

final GoRouter appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    redirect: (context, state) {
      // add some auth logic heree
      final isLoggedIn = false;
      return isLoggedIn ? '/home' : '/login';
    },
  ),

  GoRoute(
    path: '/signup',
    builder: (context, state) => const SignUp(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const Login(),
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => const Home(),
  ),
  GoRoute(
    path: '/dorm-information',
    builder: (context, state) => const DormInformation(),
  ),
  GoRoute(
    path: '/user-profile',
    builder: (context, state) => const UserProfile(),
  )
]);
