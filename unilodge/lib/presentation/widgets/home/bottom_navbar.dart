import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GNav(
          backgroundColor: AppColors.lightBackground,
          color: AppColors.primary.withOpacity(.8),
          activeColor: AppColors.lightBackground,
          tabBackgroundColor: AppColors.primary.withOpacity(.8),
          padding: const EdgeInsets.all(16),
          gap: 8,
          onTabChange: (index) {
            print(index);
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.domain,
              text: 'Listings',
            ),
            GButton(
              icon: Icons.favorite,
              text: 'Favorites',
            ),
            GButton(
              icon: Icons.forum,
              text: 'Messages',
            ),
          ]),
    );
  }
}
