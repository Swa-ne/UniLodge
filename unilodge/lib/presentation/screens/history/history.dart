import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:unilodge/bloc/booking_bloc/booking_bloc.dart';
import 'package:unilodge/bloc/booking_bloc/booking_event.dart';
import 'package:unilodge/bloc/booking_bloc/booking_state.dart';
import 'package:unilodge/common/widgets/custom_text.dart';
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
        return AppColors.pending;
      case 'accepted':
        return AppColors.greenActive;
      case 'paid':
        return AppColors.greenActive;
      case 'rejected':
        return AppColors.redInactive;
      case 'cancelled':
        return AppColors.redInactive;
      default:
        return AppColors.primary.withOpacity(0.3);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
          centerTitle: true,
          title: const CustomText(
            text: "Booking History",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Rejected'),
              Tab(text: 'Cancelled'),
              Tab(text: 'Paid'),
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
            _buildListingTab('cancelled'),
            _buildListingTab('paid')
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
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(43, 99, 100, 100),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: getStatusColor(listing.status.toLowerCase()),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          listing.listing.property_name ?? 'No Name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.primary),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          listing.listing.adddress,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          'Price: ${listing.listing.price} ETH',
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textColor),
                        ),
                        SizedBox(height: 7,),
                        Text(
                            'Booked: ${DateTime.parse(listing.createdAt).toLocal().toShortDateString()} || ${DateTime.parse(listing.createdAt).toLocal().toShortTimeString()}',
                            style: const TextStyle(
                                fontSize: 14, color: AppColors.textColor)),
                        
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),
                  // action buttons based on status
                  if (listing.status == 'Accepted')
                    _buildActionButton('Pay now', AppColors.primary, () {
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
          ),
        );
      },
    );
  }

  List<BookingHistory> _getFilteredListings(String status) {
    List<BookingHistory> filteredListings;

    if (status == 'all') {
      filteredListings = listings;
    } else {
      filteredListings = listings
          .where((listing) => listing.status.toLowerCase() == status)
          .toList();
    }

    filteredListings.sort((a, b) =>
        DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

    return filteredListings;
  }

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
    return DateFormat('MMMM d, y').format(this); 
  }

  String toShortTimeString() {
    return DateFormat.jm().format(this);
  }
}
