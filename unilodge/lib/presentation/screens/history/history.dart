import 'package:flutter/material.dart';
import 'package:unilodge/data/models/listing.dart'; 

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // Sample listings data
  final List<Listing> listings = [
    Listing(
      property_name: 'Dorm Name (Pending)',
      address: '123 Dorm St',
      status: 'pending',
      createdAt: '2024-10-12T10:09:00',
      price: '100000',
    ),
    Listing(
      property_name: 'Dorm Name (Accepted)',
      address: '456 Dorm Ave',
      status: 'accepted',
      createdAt: '2024-10-12T10:09:00',
      price: '100000',
    ),
    Listing(
      property_name: 'Dorm Name (Rejected)',
      address: '789 Dorm Blvd',
      status: 'rejected',
      createdAt: '2024-10-12T10:09:00',
      price: '100000',
    ),
  ];

  // Currently selected status
  String selectedStatus = 'all';

  // Function to return status color
  Color getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.yellow;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter listings based on selected status
    List<Listing> filteredListings = selectedStatus == 'all'
        ? listings
        : listings.where((listing) => listing.status == selectedStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Horizontal status filter
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['All', 'Pending', 'Accepted', 'Rejected'].map((status) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStatus = status.toLowerCase() == 'all' ? 'all' : status.toLowerCase();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: selectedStatus == status.toLowerCase() ? Colors.blue : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        status,
                        style: TextStyle(
                          color: selectedStatus == status.toLowerCase() ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8), // Space between filter and booking details
          Expanded(
            child: ListView.builder(
              itemCount: filteredListings.length,
              itemBuilder: (context, index) {
                final listing = filteredListings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status indicator
                      Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: getStatusColor(listing.status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (index != filteredListings.length - 1)
                            Container(
                              width: 2,
                              height: 40,
                              color: Colors.grey.shade400,
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Booking details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listing.property_name ?? 'No Name',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${listing.address ?? 'No Address'}\nBook: ${DateTime.parse(listing.createdAt!).toLocal().toShortDateString()}\nPrice: ${listing.price}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Time (Parsed from createdAt)
                      Text(
                        DateTime.parse(listing.createdAt!).toLocal().toShortTimeString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 12),
                      // Action buttons based on status
                      if (listing.status == 'accepted') 
                        _buildActionButton('To Pay', Colors.blue),
                      if (listing.status == 'rejected')
                        _buildActionButton('Book Again', Colors.grey),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  // Action Button Widget
  Widget _buildActionButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        // Handle button action
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text),
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return '${this.day}/${this.month}/${this.year}';
  }

  String toShortTimeString() {
    return '${this.hour}:${this.minute.toString().padLeft(2, '0')}';
  }
}
