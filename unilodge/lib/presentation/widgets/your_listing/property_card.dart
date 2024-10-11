import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class PropertyCard extends StatelessWidget {
  final String cardName;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  final String imageIcon;

  const PropertyCard({
    Key? key,
    required this.cardName,
    required this.description,
    required this.isSelected,
    required this.onTap,
    required this.imageIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: isSelected
            ? const Color.fromARGB(255, 245, 245, 245)
            : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF636464).withOpacity(0.15),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
            border: isSelected
                ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.0)
                : null,
          ),
          child: Center(
            // elevation: 0.5,
            // color: Colors.transparent, 
            // shadowColor: Colors.transparent, 
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(imageIcon),
              ),
              title: Text(
                cardName,
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                description,
                style: TextStyle(color: AppColors.textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
