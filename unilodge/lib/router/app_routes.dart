import 'package:go_router/go_router.dart';
import 'package:unilodge/data/dummy_data/dummy_data.dart';
import 'package:unilodge/presentation/screens/auth_screens/account_selection_login.dart';
import 'package:unilodge/presentation/screens/auth_screens/account_selection_sign_up.dart';
import 'package:unilodge/presentation/screens/auth_screens/email&password/forget_password.dart';
import 'package:unilodge/presentation/screens/auth_screens/email&password/verify_email.dart';
import 'package:unilodge/presentation/screens/auth_screens/login.dart';
import 'package:unilodge/presentation/screens/auth_screens/sign_up.dart';
import 'package:unilodge/presentation/screens/home_screens/homepage.dart';
import 'package:unilodge/presentation/screens/home_screens/listing_detail_screen.dart';
import 'package:unilodge/presentation/screens/home_screens/type_listing_screen.dart';
import 'package:unilodge/presentation/screens/your_listing_screens/edit_listing_post.dart';
import 'package:unilodge/presentation/screens/your_listing_screens/your_listing_details.dart';
import 'package:unilodge/presentation/screens/profile_screens/user_profile.dart';
import 'package:unilodge/presentation/screens/listing_screens/post_accommodation.dart';
import 'package:unilodge/presentation/screens/listing_screens/post_location.dart';
import 'package:unilodge/presentation/screens/listing_screens/post_price.dart';

final GoRouter appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    redirect: (context, state) {
      // add some auth logic heree
      const isLoggedIn = false;
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
    path: '/login',
    builder: (context, state) => const Login(),
  ),
  GoRoute(
    path: '/sign-up',
    builder: (context, state) => const SignUp(),
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/listings',
    builder: (context, state) => const HomePage(
      initialTabIndex: 1,
    ),
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
    path: '/listing-detail/:id',
    builder: (context, state) {
      // Retrieve the listing ID from the route parameters
      final listingId = state.pathParameters['id'];

      final listing =
          dummyListings.firstWhere((listing) => listing.id == listingId);

      return ListingDetailScreen(listing: listing);
    },
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
    path: '/verify-email',
    builder: (context, state) => const VerifyEmail(),
  ),
  GoRoute(
    path: '/forget-password',
    builder: (context, state) => const ForgetPassword(),
  ),
    GoRoute(
    path: '/your-listing-detail/:id',
    builder: (context, state) {
      // Retrieve the listing ID from the route parameters
      final yourListingId = state.pathParameters['id'];

      final yourListing =
          dummyListings.firstWhere((listing) => listing.id == yourListingId);

      return YourListingDetails(listing: yourListing);
    },
  ),
  GoRoute(
    path: '/edit-listing-post',
    builder: (context, state) => const EditListingPost(),
  ),
  GoRoute(
    path: '/type-listing/:type',
    builder: (context, state) {
      final type = state.pathParameters['type'];
      return TypeListingScreen(appbarTitle: type!);
    },
  ),
]);
