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
                                  extra: widget.bookingHistory.listing);
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

              // TimelineTile(
              //   alignment: TimelineAlign.manual,
              //   lineXY: 0.1,
              //   isFirst: true,
              //   beforeLineStyle: const LineStyle(
              //     color: Colors.grey,
              //     thickness: 3,
              //   ),
              //   indicatorStyle: IndicatorStyle(
              //     width: 20,
              //     color: _getStatusColor(bookingHistory.status),
              //   ),
              //   endChild: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text(
              //       bookingHistory.status == 'pending' ||
              //               bookingHistory.status == 'received'
              //           ? 'Pending/Received'
              //           : 'Pending/Received (Completed)',
              //       style: const TextStyle(fontSize: 16),
              //     ),
              //   ),
              // ),

              // if (bookingHistory.status.toLowerCase() == 'accepted' || bookingHistory.status.toLowerCase() == 'paid')
              //   TimelineTile(
              //     alignment: TimelineAlign.manual,
              //     lineXY: 0.1,
              //     isLast: bookingHistory.status.toLowerCase() == 'paid' ? false : true,
              //     beforeLineStyle: const LineStyle(
              //       color: Colors.grey,
              //       thickness: 3,
              //     ),
              //     indicatorStyle: const IndicatorStyle(
              //       width: 20,
              //       color: Colors.green,
              //     ),
              //     endChild: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           const Text(
              //             'Accepted',
              //             style: TextStyle(fontSize: 16),
              //           ),
              //           const SizedBox(height: 8),
              //           ElevatedButton(
              //             onPressed: () {
              //               // Navigate to payment screen or handle payment logic
              //               print('Proceeding to payment');
              //             },
              //             style: ElevatedButton.styleFrom(
              //               backgroundColor: AppColors.primary,
              //               padding: const EdgeInsets.symmetric(
              //                 horizontal: 24.0,
              //                 vertical: 12.0,
              //               ),
              //             ),
              //             child: const Text('Pay Now'),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),

              // if (bookingHistory.status.toLowerCase() == 'rejected')
              //   TimelineTile(
              //     alignment: TimelineAlign.manual,
              //     lineXY: 0.1,
              //     isLast: true,
              //     beforeLineStyle: const LineStyle(
              //       color: Colors.grey,
              //       thickness: 3,
              //     ),
              //     indicatorStyle: const IndicatorStyle(
              //       width: 20,
              //       color: Colors.red,
              //     ),
              //     endChild: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: const Text(
              //         'Rejected',
              //         style: TextStyle(fontSize: 16),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to get color based on booking status
  // Color _getStatusColor(String status) {
  //   switch (status) {
  //     case 'pending':
  //       return Colors.yellow;
  //     case 'accepted':
  //       return Colors.green;
  //     case 'rejected':
  //       return Colors.red;
  //     default:
  //       return Colors.grey;
  //   }
  // }
}
