import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/favorite_widgets/favorites_list_view.dart';
import 'package:unilodge/presentation/widgets/message_widgets/custom_text.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const CustomText(
          text: 'Favorites',
          color: AppColors.textColor,
          fontSize: 18,
        ),
      ),
      body: const FavoritesListView(),
    );
  }
}
