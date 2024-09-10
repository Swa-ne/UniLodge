import 'package:flutter/material.dart';
import 'favorites_card.dart';
import 'sample_favs.dart';

class FavoritesListView extends StatelessWidget {
  const FavoritesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final item = favorites[index];
          return FavoriteCard(
            image: item['image']!,
            dormName: item['dormName']!,
            address: item['address']!,
            price: item['price']!,
            rating: item['rating']!,
          );
        },
      ),
    );
  }
}
