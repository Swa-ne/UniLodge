import 'package:go_router/go_router.dart';
import 'package:unilodge/presentation/auth/pages/accountSelectionLogin.dart';
import 'package:unilodge/presentation/auth/pages/accountSelectionSignUp.dart';
import 'package:unilodge/presentation/auth/pages/email&password/forget_password.dart';
import 'package:unilodge/presentation/auth/pages/email&password/verify_email.dart';
import 'package:unilodge/presentation/home/pages/homepage.dart';
import 'package:unilodge/presentation/profile/pages/userProfile.dart';
import 'package:unilodge/presentation/post/pages/postAccommodation.dart';
import 'package:unilodge/presentation/post/pages/postLocation.dart';
import 'package:unilodge/presentation/Post/pages/PostPrice.dart';

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
    path: '/home',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/listings',
    builder: (context, state) => const HomePage(initialTabIndex: 1,),
  ),
  GoRoute(
    path: '/favorites',
    builder: (context, state) => const HomePage(
      initialTabIndex: 2,
    ),
  ),
  GoRoute(
    path: '/messages',
    builder: (context, state) => const HomePage(
      initialTabIndex: 3,
    ),
  ),
  GoRoute(
    path: '/post-accommodation',
    builder: (context, state) => const PostAccommodation(),
  ),
  GoRoute(
    path: '/post-location',
    builder: (context, state) => const PostLocation(),
  ),
  GoRoute(
    path: '/post-price',
    builder: (context, state) => const PostPrice(),
  ),
  GoRoute(
    path: '/user-profile',
    builder: (context, state) => const UserProfile(),
  ),
  GoRoute(
    path: '/verify_email',
    builder: (context, state) => const VerifyEmail(),
  ),
  GoRoute(
    path: '/forget_password',
    builder: (context, state) => const ForgetPassword(),
  ),
]);
