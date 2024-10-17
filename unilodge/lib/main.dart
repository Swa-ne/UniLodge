import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_bloc.dart';
import 'package:unilodge/bloc/chat/chat_bloc.dart';
import 'package:unilodge/bloc/listing/listing_bloc.dart';
import 'package:unilodge/bloc/my_profile/my_profile_bloc.dart';
import 'package:unilodge/bloc/renter/renter_bloc.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/core/configs/theme/app_theme.dart';
import 'package:unilodge/data/repository/admin_repository/admin_listing_repository_impl.dart';
import 'package:unilodge/data/repository/listing_repository_impl.dart';
import 'package:unilodge/data/repository/renter_repository_impl.dart';
import 'package:unilodge/data/repository/user_repository_impl.dart';
import 'package:unilodge/data/sources/auth/auth_repo.dart';
import 'package:unilodge/bloc/authentication/auth_bloc.dart';
import 'package:unilodge/data/sources/chat/chat_repo.dart';
import 'app_routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/bloc/booking_bloc/booking_bloc.dart'; // Import the BookingBloc
import 'package:unilodge/data/repository/booking_repository_impl.dart'; // Import the BookingRepositoryImpl

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.lightBackground,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(AuthRepoImpl()),
          ),
          BlocProvider(
            create: (context) => ChatBloc(ChatRepoImpl()),
          ),
          BlocProvider(
            create: (context) => ListingBloc(ListingRepositoryImpl()),
          ),
          BlocProvider(
            create: (context) =>
                RenterBloc(renterRepository: RenterRepositoryImpl()),
          ),
          BlocProvider(
              create: (context) =>
                  ProfileBloc(userRepository: UserRepositoryImpl())),
          BlocProvider(
            create: (context) => AdminBloc(AdminListingRepositoryImpl()),
          ),
           BlocProvider(
            create: (context) => BookingBloc(BookingRepositoryImpl()),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          title: 'UniLodge',
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
