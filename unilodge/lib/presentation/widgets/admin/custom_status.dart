import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class CustomStatus extends StatelessWidget {
  const CustomStatus(
      {super.key,
      required this.dataTitle,
      required this.data,
      required this.icon,
      required this.color});

  final String dataTitle;
  final String data;
  final Icon icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Center(
        child: Container(
          width: screenWidth * 0.31,
          height: screenHeight * 0.1,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(43, 99, 100, 100),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: icon,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data,
                      style:
                          TextStyle(color: AppColors.lightBackground, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      dataTitle,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightBackground),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
