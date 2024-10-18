import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/booking_bloc/booking_bloc.dart';
import 'package:unilodge/bloc/booking_bloc/booking_event.dart';
import 'package:unilodge/bloc/booking_bloc/booking_state.dart';
import 'package:unilodge/presentation/widgets/listing/booking_card.dart';

class BookingManagementWidget extends StatelessWidget {
  final String listingId;

  const BookingManagementWidget({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    context.read<BookingBloc>().add(FetchBookingsForListingEvent(listingId));

    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Color.fromARGB(255, 129, 129, 129),
            indicatorColor: Color.fromARGB(255, 0, 0, 0),
            tabs: [
              Tab(icon: Icon(Icons.pending), text: 'Pending'),
              Tab(icon: Icon(Icons.check_circle), text: 'Approved'),
              Tab(icon: Icon(Icons.cancel), text: 'Rejected'),
            ],
          ),
          SizedBox(
            height: 500,
            child: BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is BookingLoading) {
                  // Display loading indicator when bookings are being fetched
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AllBookingsLoaded) {
                  // Separate bookings into their respective categories
                  final pendingBookings = state.bookings
                      .where((booking) => booking.status == 'Pending')
                      .toList();

                  final approvedBookings = state.bookings
                      .where((booking) => booking.status == 'Approved')
                      .toList();

                  final rejectedBookings = state.bookings
                      .where((booking) => booking.status == 'Rejected')
                      .toList();

                  // Display the tab views
                  return TabBarView(
                    children: [
                      // Pending Bookings Tab
                      _buildBookingList(
                        bookings: pendingBookings,
                        onApprove: (bookingId) {
                          context
                              .read<BookingBloc>()
                              .add(ApproveBookingEvent(bookingId));
                          print('Approved booking for $bookingId');
                        },
                        onReject: (bookingId) {
                          context
                              .read<BookingBloc>()
                              .add(RejectBookingEvent(bookingId));
                          print('Rejected booking for $bookingId');
                        },
                      ),

                      // Approved Bookings Tab
                      _buildBookingList(
                        bookings: approvedBookings,
                        onApprove:
                            null, // Approved bookings cannot be approved again
                        onReject: (bookingId) {
                          context
                              .read<BookingBloc>()
                              .add(RejectBookingEvent(bookingId));
                          print('Rejected approved booking for $bookingId');
                        },
                      ),

                      // Rejected Bookings Tab
                      _buildBookingList(
                        bookings: rejectedBookings,
                        onApprove: (bookingId) {
                          context
                              .read<BookingBloc>()
                              .add(ApproveBookingEvent(bookingId));
                          print('Approved rejected booking for $bookingId');
                        },
                        onReject:
                            null, // Rejected bookings cannot be rejected again
                      ),
                    ],
                  );
                } else if (state is AllBookingsEmptyLoaded) {
                  // Display error message if an error occurs
                  return const Center(child: Text("No bookings available"));
                } else if (state is BookingError) {
                  // Display error message if an error occurs
                  return Center(child: Text(state.message));
                } else {
                  // Default state when no bookings are available
                  return const Center(child: Text('No bookings available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the booking list
  Widget _buildBookingList({
    required List<dynamic> bookings,
    required Function(String)? onApprove,
    required Function(String)? onReject,
  }) {
    if (bookings.isEmpty) {
      return const Center(child: Text('No bookings in this category'));
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return BookingCard(
          propertyType: booking.propertyType,
          userName: booking.userId.username.toString(),
          price: booking.price.toString(),
          status: booking.status,
          onApprove: onApprove != null
              ? () => onApprove(booking.id)
              : null, // Approve button is only enabled when applicable
          onReject: onReject != null
              ? () => onReject(booking.id)
              : null, // Reject button is only enabled when applicable
        );
      },
    );
  }
}
