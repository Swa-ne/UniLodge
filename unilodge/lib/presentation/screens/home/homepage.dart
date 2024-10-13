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

  Widget _buildIcon(String assetPath) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        _selectedIndex == _getIndex(assetPath)
            ? AppColors.primary
            : const Color.fromARGB(255, 119, 142, 160),
        BlendMode.srcIn,
      ),
      child: Image.asset(assetPath, width: 24),
    );
  }

  int _getIndex(String assetPath) {
    switch (assetPath) {
      case AppImages.homeeIcon:
        return 0;
      case AppImages.listingIcon:
        return 1;
      case AppImages.favoriteIcon:
        return 2;
      case AppImages.messageIcon:
        return 3;
      default:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, -3),
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
                  icon: _buildIcon(AppImages.homeeIcon), label: 'Home'),
              BottomNavigationBarItem(
                  icon: _buildIcon(AppImages.listingIcon), label: 'Listings'),
              BottomNavigationBarItem(
                  icon: _buildIcon(AppImages.favoriteIcon), label: 'Favorites'),
              BottomNavigationBarItem(
                  icon: _buildIcon(AppImages.messageIcon), label: 'Messages'),
            ],
          ),
        ),
      ),
    );
  }
}
