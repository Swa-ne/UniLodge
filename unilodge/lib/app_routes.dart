import 'package:go_router/go_router.dart';
import 'package:unilodge/presentation/auth/pages/accountSelectionLogin.dart';
import 'package:unilodge/presentation/auth/pages/accountSelectionSignUp.dart';
import 'package:unilodge/presentation/auth/pages/login.dart';
import 'package:unilodge/presentation/auth/pages/signUp.dart';
import 'package:unilodge/presentation/favorite/pages/favorites.dart';
import 'package:unilodge/presentation/home/pages/home.dart';
import 'package:unilodge/presentation/message/pages/messages.dart';
import 'package:unilodge/presentation/profile/pages/userProfile.dart';
import 'package:unilodge/presentation/post/pages/postaccommodation.dart';

final GoRouter appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    redirect: (context, state) {
      // add some auth logic heree
      final isLoggedIn = false;
      // ignore: dead_code
      return isLoggedIn ? '/home' : '/account-selection-login';
    },
  ),

  GoRoute(
    path: '/account-selection-login',
    builder: (context, state) => const AccountSelectionLogin(),
  ),
  GoRoute(
    path: '/account-selection-signup',
    builder: (context, state) => const AccountSelectionSignup(),
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
    path: '/postAccommodation',
    builder: (context, state) => const Postaccommodation(),
  ),
  // GoRoute(
  //   path: '/dorm-information',
  //   builder: (context, state) => const ListingDetailScreen(),
  // ),
  GoRoute(
    path: '/user-profile',
    builder: (context, state) => const UserProfile(),
  ),
  GoRoute(
    path: '/messages',
    builder: (context, state) => const Messages(),
  ),
  GoRoute(
    path: '/favorites',
    builder: (context, state) => const Favorites(),
  )
]);
