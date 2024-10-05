import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/screens/favorite/favorites.dart';
import 'package:unilodge/presentation/screens/home/home.dart';
import 'package:unilodge/presentation/screens/yourLIsting/yourListings.dart';
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
    Home(),
    Listings(),
    Favorites(),
    Messages(),
  ];

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
                offset: Offset(0, -3),
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
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Home'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.domain), label: 'Listings'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorites'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.forum), label: 'Messages'),
            ],
            // items: [
            //   BottomNavigationBarItem(
            //       icon: Image.asset(AppImages.homeIcon), label: 'Home'),
            //   BottomNavigationBarItem(
            //       icon: Image.asset(AppImages.listingIcon), label: 'Listings'),
            //   BottomNavigationBarItem(
            //       icon: Image.asset(AppImages.favoriteIcon),
            //       label: 'Favorites'),
            //   BottomNavigationBarItem(
            //       icon: Image.asset(AppImages.messageIcon), label: 'Messages'),
            // ],
          ),
        ),
      ),
    );
  }
}
