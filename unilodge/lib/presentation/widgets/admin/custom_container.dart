import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';

class CustomContainer extends StatefulWidget {
  CustomContainer({super.key, required this.dataTitle, required this.data, required this.icon});
  final String dataTitle;
  final String data;
  final Icon icon;

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Container(
          width: screenWidth * 0.93,
          height: screenHeight * 0.15,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
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
                padding: const EdgeInsets.only(left: 35.0),
                child: widget.icon,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text(widget.data, style: TextStyle(color: AppColors.textColor, fontSize: 20),), SizedBox(height: 15,), Text(widget.dataTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary), )],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
