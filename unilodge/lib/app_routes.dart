import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/admin_bloc/my_profile/my_profile_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/my_profile/my_profile_state.dart';
import 'package:unilodge/data/models/booking_history.dart';
import 'package:unilodge/data/models/inbox.dart';
import 'package:unilodge/data/models/user_profile.dart';
import 'package:unilodge/presentation/screens/admin/admin_listing_details_screen.dart';
import 'package:unilodge/presentation/screens/admin/admin_user_dorm_screen.dart';
import 'package:unilodge/presentation/screens/admin/admin_users_screen.dart';
import 'package:unilodge/presentation/screens/admin/dashboard.dart';
import 'package:unilodge/presentation/screens/admin/admin_listings_screen.dart';
import 'package:unilodge/presentation/screens/admin/status_listing_screen.dart';
import 'package:unilodge/presentation/screens/auth/change_forgotten_password.dart';
import 'package:unilodge/presentation/screens/auth/change_password.dart';
import 'package:unilodge/presentation/screens/crypto/payment_page.dart';
import 'package:unilodge/presentation/screens/crypto/success_transaction.dart';
import 'package:unilodge/presentation/screens/help_center/help_center.dart';
import 'package:unilodge/presentation/screens/auth/account_selection_login.dart';
import 'package:unilodge/presentation/screens/auth/account_selection_sign_up.dart';
import 'package:unilodge/presentation/screens/auth/forget_password.dart';
import 'package:unilodge/presentation/screens/auth/login.dart';
import 'package:unilodge/presentation/screens/auth/sign_up.dart';
import 'package:unilodge/presentation/screens/auth/verify_email.dart';
import 'package:unilodge/presentation/screens/edit_profile/edit_profile_info.dart';
import 'package:unilodge/presentation/screens/history/booked_details.dart';
import 'package:unilodge/presentation/screens/home/homepage.dart';
import 'package:unilodge/presentation/screens/home/listing_details_screen.dart';
import 'package:unilodge/presentation/screens/home/type_listing_screen.dart';
import 'package:unilodge/presentation/screens/message/chat.dart';
import 'package:unilodge/presentation/screens/profile/my_profile.dart';
import 'package:unilodge/presentation/screens/settings_ui/settings.dart';
import 'package:unilodge/presentation/screens/history/history.dart';
import 'package:unilodge/presentation/screens/verify_user/check_face.dart';
import 'package:unilodge/presentation/screens/verify_user/check_id.dart';
import 'package:unilodge/presentation/screens/verify_user/face_details.dart';
import 'package:unilodge/presentation/screens/verify_user/id_details.dart';
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
import 'package:unilodge/presentation/widgets/admin/your_admin_listing_details.dart';
import 'package:unilodge/presentation/widgets/listing/tab_bar.dart';

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
      path: '/verify-face',
      builder: (context, state) => const CheckFaceScreen(),
    ),
    GoRoute(
      path: '/verify-id',
      builder: (context, state) => const CheckIDScreen(),
    ),
    GoRoute(
      path: '/id-details',
      builder: (context, state) => const IdDetails(),
    ),
    GoRoute(
      path: '/face-details',
      builder: (context, state) => const FaceDetails(),
    ),
    GoRoute(
      path: '/help-center',
      builder: (context, state) => const HelpCenter(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => History(),
    ),
    GoRoute(
      path: '/booking-details',
      builder: (context, state) {
        return BookedDetails(bookingHistory: state.extra as BookingHistory);
      },
    ),
    GoRoute(
      path: '/crypto-payment',
      builder: (context, state) {
        return PaymentPage(bookingHistory: state.extra as BookingHistory); 
      },
    ),
    GoRoute(
      path: '/crypto-payment-transaction',
      builder: (context, state) {
        final extras = state.extra as Map<dynamic, dynamic>;
        return SuccessTransaction(
            transactionResult: extras['transactionResult'],
            listing: extras['listing']);
      },
    ),
    GoRoute(
      path: '/booking-management',
      builder: (context, state) {
        // Fetching the current user profile from ProfileBloc or AuthBloc
        final profileState = BlocProvider.of<ProfileBloc>(context).state;
        String username = 'Guest'; // Default to 'Guest' if not logged in

        if (profileState is ProfileLoaded) {
          username =
              profileState.username; // Fetch the actual username from profile
        }

        // Check if state.extra is null or doesn't contain 'listingId'
        final extraData =
            state.extra as Map<String, dynamic>?; // Safely cast extra to Map
        if (extraData == null || extraData['listingId'] == null) {
          return const Scaffold(
            body: Center(
              child: Text('Invalid listing or booking data'),
            ),
          );
        }

        // Safely accessing the listingId and other fields
        final listingId = extraData['listingId'] as String;

        // Include the real username in the booking data
        extraData['userName'] = username;

        // Pass listingId to BookingManagementWidget
        return BookingManagementWidget(listingId: listingId);
      },
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
    // TODO: admin routes
    GoRoute(
      path: '/admin-dashboard',
      builder: (context, state) => const Dashboard(),
    ),
    GoRoute(
      path: '/admin-dashboard-users',
      builder: (context, state) => const AdminUsersScreen(),
    ),
    GoRoute(
        path: '/admin/user-dorms',
        builder: (context, state) {
          return AdminUserDormsScreen(user: state.extra as UserProfileModel);
        }),
    GoRoute(
      path: '/your-admin-listing-detail',
      builder: (context, state) =>
          YourAdminListingDetails(listing: state.extra as Listing),
    ),
    GoRoute(
      path: '/admin-dashboard-listings',
      builder: (context, state) => const AdminListingsScreen(),
    ),
    GoRoute(
      path: '/admin/listing-details',
      builder: (context, state) =>
          AdminListingDetailScreen(listing: state.extra as Listing),
    ),
    GoRoute(
      path: '/status-listing/:status',
      builder: (context, state) {
        final status = state.pathParameters['status'];
        return StatusListingScreen(listingStatus: status!);
      },
    ),
  ],
);
