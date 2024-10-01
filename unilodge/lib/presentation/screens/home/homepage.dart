import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/screens/favorite/favorites.dart';
import 'package:unilodge/presentation/screens/home/home.dart';
import 'package:unilodge/presentation/screens/your_listing/your_listings.dart';
import 'package:unilodge/presentation/screens/message/messages.dart';
// import 'package:unilodge/presentation/screens/listing_screens/listing_page.dart';

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
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.domain), label: 'Listings'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorites'),
              BottomNavigationBarItem(
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
