import 'package:flutter/material.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class CustomConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const CustomConfirmDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog( 
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            const Text(
              'Confirm Unsaved',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Are you sure you want to unsave this dorm?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton( 
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), 
                    ),
                  ),
                  child: const CustomText(text: 'No', color: Colors.black,),
                ),
                ElevatedButton(
                  onPressed: () {
                    onConfirm();
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), 
                      
                    ),
                    backgroundColor: AppColors.redInactive
                  ),
                  child: const CustomText(text: 'Yes', color: Colors.white,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
