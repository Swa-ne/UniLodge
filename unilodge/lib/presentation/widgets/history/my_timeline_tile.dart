import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/widgets/history/timeline_card.dart';

class MyTimelineTile extends StatelessWidget {
  const MyTimelineTile(
      {super.key,
      required this.listingStatus,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      required this.child,
      required this.Icon});

  final String listingStatus;
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final child;
  final Icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          TimelineTile(
            isFirst: isFirst,
            isLast: isLast,
            beforeLineStyle:
                LineStyle(color: AppColors.primary.withOpacity(0.6)),
            indicatorStyle: IndicatorStyle(
                width: 37,
                color: AppColors.lightBackground,
                iconStyle: IconStyle(
                    iconData: Icon, color: AppColors.primary, fontSize: 22)),
            endChild: TimelineCard(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
