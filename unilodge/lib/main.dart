import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/core/configs/theme/app_theme.dart';
import 'package:unilodge/data/sources/auth/authRepo.dart';
import 'package:unilodge/presentation/auth/bloc/auth_bloc.dart';
import 'app_routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      child: BlocProvider(
          create: (context) => AuthBloc(AuthRepoImpl()),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            title: 'UniLodge',
            routerConfig: appRouter,
          )),
    );
  }
}
