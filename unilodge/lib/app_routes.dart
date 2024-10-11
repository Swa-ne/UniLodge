import 'package:go_router/go_router.dart';
import 'package:unilodge/data/models/inbox.dart';
import 'package:unilodge/presentation/screens/auth/change_forgotten_password.dart';
import 'package:unilodge/presentation/screens/auth/change_password.dart';
import 'package:unilodge/presentation/screens/help_center/help_center.dart';
import 'package:unilodge/presentation/screens/auth/account_selection_login.dart';
import 'package:unilodge/presentation/screens/auth/account_selection_sign_up.dart';
import 'package:unilodge/presentation/screens/auth/forget_password.dart';
import 'package:unilodge/presentation/screens/auth/login.dart';
import 'package:unilodge/presentation/screens/auth/sign_up.dart';
import 'package:unilodge/presentation/screens/auth/verify_email.dart';
import 'package:unilodge/presentation/screens/edit_profile/edit_profile_info.dart';
import 'package:unilodge/presentation/screens/home/homepage.dart';
import 'package:unilodge/presentation/screens/home/listing_details_screen.dart';
import 'package:unilodge/presentation/screens/home/type_listing_screen.dart';
import 'package:unilodge/presentation/screens/message/chat.dart';
import 'package:unilodge/presentation/screens/profile/my_profile.dart';
import 'package:unilodge/presentation/screens/settings_ui/settings.dart';
import 'package:unilodge/presentation/screens/your_listing/edit_listing_post.dart';
import 'package:unilodge/presentation/screens/your_listing/your_listing_details.dart';
import 'package:unilodge/presentation/screens/profile/user_profile.dart';
import 'package:unilodge/presentation/screens/listing/post_accommodation.dart';
import 'package:unilodge/presentation/screens/listing/post_location.dart';
import 'package:unilodge/presentation/screens/listing/post_price.dart';
import 'package:unilodge/presentation/screens/listing/post_facility.dart';
import 'package:unilodge/presentation/screens/listing/post_image.dart';
import 'package:unilodge/presentation/screens/listing/post_review.dart';
import 'package:unilodge/presentation/screens/onboarding/onboarding_view.dart';
import 'package:unilodge/presentation/screens/splashscreen/spash_screen.dart';

import 'package:unilodge/data/models/listing.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const SplashScreen(), // Start with splash screen
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingView(),
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
      path: '/chat/:chat_id',
      builder: (context, state) {
        final chat_id = state.pathParameters['chat_id'];
        final inbox = state.extra as InboxModel;

        if (chat_id != null) {
          return Chat(
            chat_id: chat_id,
            inbox: inbox,
          );
        }
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/listing-detail',
      builder: (context, state) {
        final listing = state.extra as Listing;
        return ListingDetailScreen(listing: listing);
      },
    ),
    GoRoute(
      path: '/post-accommodation',
      builder: (context, state) {
        final listing = state.extra as Listing? ?? Listing();
        return PostAccommodation(listing: listing);
      },
    ),
    GoRoute(
      path: '/post-location',
      builder: (context, state) {
        final selectedPropertyType = state.extra as String;
        return PostLocation(selectedPropertyType: selectedPropertyType);
      },
    ),
    GoRoute(
      path: '/post-price',
      builder: (context, state) {
        final listing = state.extra as Listing? ?? Listing();
        return PostPrice(listing: listing);
      },
    ),
    GoRoute(
      path: '/post-facility',
      builder: (context, state) {
        final listing = state.extra as Listing? ?? Listing();
        return PostFacility(listing: listing);
      },
    ),
    GoRoute(
      path: '/post-image',
      builder: (context, state) {
        final listing = state.extra as Listing;
        return PostImage(listing: listing);
      },
    ),
    GoRoute(
      path: '/post-review',
      builder: (context, state) {
        final listing = state.extra as Listing? ?? Listing();
        return PostReview(listing: listing);
      },
    ),
    GoRoute(
      path: '/user-profile',
      builder: (context, state) => const UserProfile(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final email = extras['email_address'] as String;
        final token = extras['token'] as String;

        return VerifyEmail(email_address: email, token: token);
      },
    ),
    GoRoute(
      path: '/forget-password',
      builder: (context, state) => const ForgetPassword(),
    ),
    GoRoute(
        path: '/your-listing-detail',
        builder: (context, state) =>
            YourListingDetails(listing: state.extra as Listing)),
    GoRoute(
        path: '/edit-listing-post',
        builder: (context, state) =>
            EditListingPost(listing: state.extra as Listing)),
    GoRoute(
      path: '/type-listing/:type',
      builder: (context, state) {
        final type = state.pathParameters['type'];
        return TypeListingScreen(listingType: type!);
      },
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfile(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const Settings(),
    ),
    GoRoute(
      path: '/my-profile',
      builder: (context, state) => const MyProfile(),
    ),
    GoRoute(
      path: '/help-center',
      builder: (context, state) => const HelpCenter(),
    ),
    GoRoute(
      path: '/change-password/:token',
      builder: (context, state) {
        final token = state.pathParameters['token'];
        return ChangePassword(token: token!);
      },
    ),
    GoRoute(
      path: '/change-forgotten-password/:token',
      builder: (context, state) {
        final token = state.pathParameters['token'];
        return ChangeForgottenPassword(token: token!);
      },
    ),
  ],
);
