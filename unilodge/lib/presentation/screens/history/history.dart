import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/booking_bloc/booking_bloc.dart';
import 'package:unilodge/bloc/booking_bloc/booking_event.dart';
import 'package:unilodge/bloc/booking_bloc/booking_state.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/booking_history.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<BookingHistory> listings = [];

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
    _tabController = TabController(length: 4, vsync: this);
    BlocProvider.of<BookingBloc>(context).add(GetBookingsOfUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingsOfUserLoaded) {
          setState(() {
            listings = state.listings;
          });
        } else if (state is BookingsOfUserEmptyLoaded) {
          // handle empty state
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking History'),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildListingTab('all'),
            _buildListingTab('pending'),
            _buildListingTab('accepted'),
            _buildListingTab('rejected'),
          ],
        ),
      ),
    );
  }

  Widget _buildListingTab(String status) {
    List<BookingHistory> filteredListings = _getFilteredListings(status);

    if (filteredListings.isEmpty) {
      return const Center(
        child: Text('No listings found.'),
      );
    }

    return ListView.builder(
      itemCount: filteredListings.length,
      itemBuilder: (context, index) {
        final listing = filteredListings[index];
        return GestureDetector(
          onTap: () {
            context.push('/booking-details', extra: listing);
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                // time
                Text(
                  DateTime.parse(listing.createdAt)
                      .toLocal()
                      .toShortTimeString(),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 12),
                // action buttons based on status
                if (listing.status == 'Accepted')
                  _buildActionButton('To Pay', AppColors.primary, () {
                    context.push('/crypto-payment', extra: listing);

                    print(
                        "Proceed to payment for ${listing.listing.property_name}");
                  }),
                if (listing.status == 'Rejected')
                  _buildActionButton('Book Again', Colors.grey, () {
                    context.push('/listing-detail', extra: listing.listing);
                    print(
                        "Attempt to re-book ${listing.listing.property_name}");
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  // filter Listings based on status
  List<BookingHistory> _getFilteredListings(String status) {
    if (status == 'all') {
      return listings;
    } else {
      return listings
          .where((listing) => listing.status.toLowerCase() == status)
          .toList();
    }
  }

  // action button widget
  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.lightBackground,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return '$day/$month/$year';
  }

  String toShortTimeString() {
    return '$hour:${minute.toString().padLeft(2, '0')}';
  }
}
