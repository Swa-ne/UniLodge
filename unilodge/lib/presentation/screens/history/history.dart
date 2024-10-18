import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/booking_bloc/booking_bloc.dart';
import 'package:unilodge/bloc/booking_bloc/booking_event.dart';
import 'package:unilodge/bloc/booking_bloc/booking_state.dart';
import 'package:unilodge/data/models/booking_history.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<BookingHistory> listings = [];

  String selectedStatus = 'all';

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
  void initState() {
    super.initState();
    BlocProvider.of<BookingBloc>(context).add(GetBookingsOfUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    // Filter listings based on selected status
    List<BookingHistory> filteredListings = selectedStatus == 'all'
        ? listings
        : listings
            .where((listing) => listing.status.toLowerCase() == selectedStatus)
            .toList();

    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingsOfUserLoaded) {
          setState(() {
            listings = state.listings;
            filteredListings = selectedStatus == 'all'
                ? listings
                : listings
                    .where((listing) =>
                        listing.status.toLowerCase() == selectedStatus)
                    .toList();
          });
        } else if (state is BookingsOfUserEmptyLoaded) {}
      },
      child: Scaffold(
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
                children:
                    ['All', 'Pending', 'Accepted', 'Rejected'].map((status) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedStatus = status.toLowerCase() == 'all'
                            ? 'all'
                            : status.toLowerCase();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: selectedStatus == status.toLowerCase()
                            ? Colors.blue
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          status,
                          style: TextStyle(
                            color: selectedStatus == status.toLowerCase()
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
                height: 8), // Space between filter and booking details
            Expanded(
              child: ListView.builder(
                itemCount: filteredListings.length,
                itemBuilder: (context, index) {
                  final listing = filteredListings[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
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
                                listing.listing.property_name ?? 'No Name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${listing.listing.address ?? 'No Address'}\nBook: ${DateTime.parse(listing.createdAt).toLocal().toShortDateString()}\nPrice: ${listing.listing.price}',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Time (Parsed from createdAt)
                        Text(
                          DateTime.parse(listing.createdAt)
                              .toLocal()
                              .toShortTimeString(),
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
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: ElevatedButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     child: const Text('Cancel'),
        //   ),
        // ),
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
