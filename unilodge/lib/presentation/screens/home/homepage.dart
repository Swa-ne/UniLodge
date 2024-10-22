import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/screens/favorite/favorites.dart';
import 'package:unilodge/presentation/screens/home/home.dart';
import 'package:unilodge/presentation/screens/your_listing/your_listings.dart';
import 'package:unilodge/presentation/screens/message/messages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const Home(),
    const Listings(),
    const Favorites(),
    const Messages(),
  ];

  Widget _buildIcon(
      String selectedIconPath, String unselectedIconPath, int index) {
    return Image.asset(
        _selectedIndex == index ? selectedIconPath : unselectedIconPath,
        width: 24,
        color: AppColors.primary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(202, 255, 255, 255),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.primary.withOpacity(0.8),
          backgroundColor: AppColors.lightBackground,
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(
                  AppImages.homeeIcon, AppImages.homeUnselectedIcon, 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                  AppImages.listingIcon, AppImages.listingUnselectedIcon, 1),
              label: 'Listings',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                  AppImages.favoriteIcon, AppImages.favoriteUnselectedIcon, 2),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                  AppImages.messageIcon, AppImages.messageUnselectedIcon, 3),
              label: 'Messages',
            )
          ],
        ),
      ),
    );
  }
}
