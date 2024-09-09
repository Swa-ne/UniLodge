import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.cardName,
    required this.description,
  });

  final String cardName;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      height: 130,
      child: Card(
        color: Colors.white,
        elevation: 0, // Removes the shadow to make it appear outlined
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon or Image Section
              // Padding(
              //   padding: const EdgeInsets.only(right: 12.0),
              //   child: Icon(
              //     Icons.bed, // Change this to your specific icon if available
              //     size: 40,
              //     color: Colors.blueGrey,
              //   ),
              // ),
              // Text Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cardName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(221, 40, 47, 54),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
