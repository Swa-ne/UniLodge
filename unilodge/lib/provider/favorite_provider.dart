
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilodge/data/models/listing.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Listing> _favorite = [];
  List<Listing> get favorites => _favorite;
  void toggleFavorite(Listing listing) {
    if (_favorite.contains(listing)) {
      _favorite.remove(listing);
    } else {
      _favorite.add(listing);
    }
    notifyListeners();
  }

  bool isExist(Listing listing) {
    final isExist = _favorite.contains(listing);
    return isExist;
  }

  static FavoriteProvider of(BuildContext context, { bool listen = true}) {
    return Provider.of<FavoriteProvider>(
      context,
      listen: listen,
    );
  } 
}

