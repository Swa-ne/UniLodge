import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final String propertyType;
  final String userName;
  final String price;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const BookingCard({
    super.key,
    required this.propertyType,
    required this.userName,
    required this.price,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Property Type: $propertyType',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8),
            Text('User: $userName'),
            const SizedBox(height: 8),
            Text('Price: $price'),
            
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onApprove != null)
                
                   ElevatedButton(
                    onPressed: onReject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 244, 120, 120),
                       foregroundColor: Colors.white,
                    ),
                    child: const Text('Rejected'),
                  ),
                const SizedBox(width: 8),
                if (onReject != null)
                    ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 117, 206, 163),
                       foregroundColor: Colors.white,
                    ),
                    child: const Text('Approved'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
