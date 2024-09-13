import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/favorite/pages/favorites.dart';
import 'package:unilodge/presentation/home/pages/home.dart';
import 'package:unilodge/presentation/home/widgets/bottomNavbar.dart';
import 'package:unilodge/presentation/home/widgets/typeCards.dart';
import 'package:unilodge/presentation/home/widgets/listingCards.dart';
import 'package:unilodge/presentation/home/widgets/search.dart';
import 'package:unilodge/presentation/message/pages/messages.dart';
import 'package:unilodge/presentation/profile/pages/userProfile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [Home(), Home(), Favorites(), Messages()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.primary.withOpacity(0.7),
          backgroundColor: AppColors.lightBackground,
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.domain), label: 'Listings'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Messages')
          ]),
    );
  }
}
