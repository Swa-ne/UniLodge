import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/bloc/booking_bloc/booking_bloc.dart';
import 'package:unilodge/bloc/booking_bloc/booking_event.dart';
import 'package:unilodge/bloc/booking_bloc/booking_state.dart';
import 'package:unilodge/bloc/chat/chat_bloc.dart';
import 'package:unilodge/bloc/chat/chat_event.dart';
import 'package:unilodge/bloc/chat/chat_state.dart';
import 'package:unilodge/common/widgets/custom_button.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/booking_history.dart';
import 'package:unilodge/presentation/widgets/history/booked_listing_details.dart';
import 'package:unilodge/presentation/widgets/history/my_timeline_tile.dart';

class BookedDetails extends StatefulWidget {
  const BookedDetails({super.key, required this.bookingHistory});

  final BookingHistory bookingHistory;

  @override
  State<BookedDetails> createState() => _BookedDetailsState();
}

class _BookedDetailsState extends State<BookedDetails> {
  @override
  Widget build(BuildContext context) {
    final bookingHistory = widget.bookingHistory;
    final _chatBloc = BlocProvider.of<ChatBloc>(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingCancelled) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Booking cancelled successfully")),
              );
              context.pushReplacement('/history'); // Navigate without stacking
            }
          },
        ),
        BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is CreateInboxSuccess) {
              context.push('/chat/${state.inbox.id}', extra: state.inbox);
            } else if (state is CreateInboxError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(bookingHistory.listing.property_name!),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(.1)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    children: [
                      MyTimelineTile(
                        listingStatus: bookingHistory.status,
                        isFirst: true,
                        isLast: bookingHistory.status.toLowerCase() == 'accepted' ||
                                bookingHistory.status.toLowerCase() == 'paid'
                            ? false
                            : true,
                        isPast: true,
                        Icon: Icons.hourglass_bottom,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Pending",
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text(
                                "The owner of ${bookingHistory.listing.property_name} has received your request to rent the place. Please wait for them to accept your request.",
                                style: const TextStyle(color: AppColors.textColor)),
                          ],
                        ),
                      ),
                      if (bookingHistory.status.toLowerCase() == 'accepted' ||
                          bookingHistory.status.toLowerCase() == 'paid')
                        MyTimelineTile(
                          listingStatus: bookingHistory.status,
                          isFirst: false,
                          isLast: bookingHistory.status.toLowerCase() == 'paid'
                              ? false
                              : true,
                          isPast: true,
                          Icon: Icons.done,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Accepted",
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text(
                                  "The owner of ${bookingHistory.listing.property_name} has accepted your request to rent the place.",
                                  style: const TextStyle(color: AppColors.textColor)),
                              if (bookingHistory.status.toLowerCase() != "paid")
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: () {
                                      context.push('/crypto-payment',
                                          extra: widget.bookingHistory);
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "Pay now",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      if (bookingHistory.status.toLowerCase() == 'rejected')
                        MyTimelineTile(
                          listingStatus: bookingHistory.status,
                          isFirst: false,
                          isLast: bookingHistory.status.toLowerCase() == 'paid'
                              ? false
                              : true,
                          isPast: true,
                          Icon: Icons.close,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Rejected",
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text(
                                  "The owner of ${bookingHistory.listing.property_name} has rejected your request to rent the place.",
                                  style: const TextStyle(color: AppColors.textColor)),
                            ],
                          ),
                        ),
                      if (bookingHistory.status.toLowerCase() == 'paid')
                        MyTimelineTile(
                          listingStatus: bookingHistory.status,
                          isFirst: false,
                          isLast: true,
                          isPast: false,
                          Icon: Icons.payments,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Paid",
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text("The owner has received the payment.",
                                  style: TextStyle(color: AppColors.textColor)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(height: 20, color: AppColors.lightBackground),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 16),
                      child: Text("Property Details",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary)),
                    ),
                  ],
                ),
                BookedListingDetails(listing: widget.bookingHistory.listing),
                if (bookingHistory.status.toLowerCase() != "paid" &&
                    bookingHistory.status.toLowerCase() != "cancelled")
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomButton(
                          text: "Cancel",
                          onPressed: () {
                            _showCancelConfirmationDialog(context, bookingHistory.id!);
                          })),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _chatBloc.add(CreateInboxEvent(widget.bookingHistory.listing.owner_id!.id));
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.message, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _showCancelConfirmationDialog(BuildContext context, String bookingId) async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Cancellation"),
          content: const Text("Are you sure you want to cancel this booking?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<BookingBloc>(context).add(CancelBookingEvent(bookingId));
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
