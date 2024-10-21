import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final String propertyType;
  final String userName;
  final String price;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final String status;

  const BookingCard({
    super.key,
    required this.propertyType,
    required this.userName,
    required this.price,
    this.onApprove,
    this.onReject,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.white,
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
                    if (onApprove != null && status != 'Rejected')
                      ElevatedButton(
                        onPressed: onApprove,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 117, 206, 163),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Approve'),
                      ),
                    const SizedBox(width: 8),
                    if (onReject != null && status != 'Rejected')
                      ElevatedButton(
                        onPressed: onReject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 244, 120, 120),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reject'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Displaying status badge (Paid, Pending, etc.)
        if (status.isNotEmpty)
          Positioned(
            top: 15,
            right: 22,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: _getStatusColor(status),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                _getStatusText(status), // Display the updated status text
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Method to display 'Approved' instead of 'Accepted'
  String _getStatusText(String status) {
    if (status == 'Accepted') {
      return 'Approved'; // Change 'Accepted' to 'Approved'
    }
    return status; // Return the original status for other cases
  }

  // Method to handle various statuses and assign colors
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color.fromARGB(255, 76, 175, 80);
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      case 'Accepted': // Accepted will show the 'Approved' label but use this color
        return const Color.fromARGB(255, 76, 175, 80);
      default:
        return const Color.fromARGB(255, 76, 175, 80); // Default case for unknown statuses
    }
  }
}
