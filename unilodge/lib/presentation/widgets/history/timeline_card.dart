import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class TimelineCard extends StatelessWidget {
  const TimelineCard({super.key, required this.child});

  final child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(8)),
      child: child,
    );
  }
}
