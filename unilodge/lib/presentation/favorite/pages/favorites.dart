import 'package:flutter/material.dart';
import 'package:unilodge/presentation/favorite/widgets/favorites_list_view.dart';
import 'package:unilodge/presentation/message/widgets/custom_text.dart';

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
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      body: const FavoritesListView(),
    );
  }
}
