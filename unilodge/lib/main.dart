import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_theme.dart';
import 'app_routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        title: 'UniLodge',
        routerConfig: appRouter,
      ),
    );
  }
}
