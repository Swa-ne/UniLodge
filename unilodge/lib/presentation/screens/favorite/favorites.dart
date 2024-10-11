
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/provider/favorite_provider.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final List<Listing> favorites = favoriteProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorites'),
        centerTitle: true,
        backgroundColor: AppColors.lightBackground,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Text(
                'No favorites yet!',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final Listing dorm = favorites[index];
                return ListTile(
                  leading: dorm.imageUrl != null
                      ? Image.network(
                          dorm.imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        ),
                  title: Text(
                    dorm.property_name ?? 'Unnamed Property',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                  subtitle: Text(
                    dorm.address ?? '',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      favoriteProvider.toggleFavorite(dorm);
                    },
                  ),
                  onTap: () {
                    context.push('/listing-detail/${dorm.id}');
                  },
                );
              },
            ),
    );
  }
}
