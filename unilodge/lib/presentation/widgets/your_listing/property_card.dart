// property_card.dart
import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class PropertyCard extends StatelessWidget {
  final String cardName;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const PropertyCard({
    Key? key,
    required this.cardName,
    required this.description,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? const Color.fromARGB(255, 245, 245, 245) : Colors.white,
        elevation: 0.5,
        child: ListTile(
          leading: const Icon(Icons.bed, size: 50, color: AppColors.logoTextColor,),
          title: Text(cardName, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),),
          subtitle: Text(description,
            style: TextStyle(
                color: AppColors.textColor),
          ),
        ),
      ),
    );
  }
}
