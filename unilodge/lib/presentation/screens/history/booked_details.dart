import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/booking_history.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(bookingHistory.listing.property_name!),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(.1)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            children: [
              MyTimelineTile(
                listingStatus: bookingHistory.status,
                isFirst: true,
                isLast: bookingHistory.status.toLowerCase() == 'accepted' ||
                        bookingHistory.status.toLowerCase() == 'paid'
                    ? false
                    : true,
                isPast: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pending",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        "The owner of ${bookingHistory.listing.property_name} has received your request to rent the place. Please wait for them to accept your request.",
                        style: TextStyle(
                          color: AppColors.textColor,
                        ))
                  ],
                ),
                Icon: Icons.hourglass_bottom,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Accepted",
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "The owner of ${bookingHistory.listing.property_name} has accepted your request to rent the place.",
                          style: TextStyle(
                            color: AppColors.textColor,
                          )),
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
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Icon: Icons.done,
                ),
              if (bookingHistory.status.toLowerCase() == 'rejected')
                MyTimelineTile(
                  listingStatus: bookingHistory.status,
                  isFirst: false,
                  isLast: bookingHistory.status.toLowerCase() == 'paid'
                      ? false
                      : true,
                  isPast: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rejected",
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "The owner of ${bookingHistory.listing.property_name} has rejected your request to rent the place",
                          style: TextStyle(
                            color: AppColors.textColor,
                          ))
                    ],
                  ),
                  Icon: Icons.close,
                ),
              if (bookingHistory.status.toLowerCase() == 'paid')
                MyTimelineTile(
                  listingStatus: bookingHistory.status,
                  isFirst: false,
                  isLast: true,
                  isPast: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Paid",
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Text("The owner has received the payment.",
                          style: TextStyle(
                            color: AppColors.textColor,
                          ))
                    ],
                  ),
                  Icon: Icons.payments,
                )
            ],
          ),
        ),
      ),
    );
  }
}
