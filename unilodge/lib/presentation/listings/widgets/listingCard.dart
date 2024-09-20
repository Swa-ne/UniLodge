import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
      child: GestureDetector(
        onTap: () async {
          
        },

        child: Container(
          height: 110,
          decoration: const BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(43, 99, 100, 100),
                offset: const Offset(0, 2),
                blurRadius: 8, 
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8.0, right: 15, bottom: 8, left: 15),
            child: Row(
              children: [
                Text("your dorm name here"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}