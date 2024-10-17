// import 'package:flutter/material.dart';
// import 'package:unilodge/presentation/widgets/listing/booking_card.dart';

// class BookingManagementWidget extends StatelessWidget {
//    final Map<String, dynamic> bookingData;  // Accept booking data

//   const BookingManagementWidget({super.key, required this.bookingData});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const TabBar(
//             labelColor: Colors.black,
//             unselectedLabelColor: Color.fromARGB(255, 129, 129, 129),
//             indicatorColor: Color.fromARGB(255, 0, 0, 0),
//             tabs: [
//               Tab(
//                 icon: Icon(Icons.pending),
//                 text: 'Pending',
//               ),
//               Tab(
//                 icon: Icon(Icons.check_circle),
//                 text: 'Approved',
//               ),
//               Tab(
//                 icon: Icon(Icons.cancel),
//                 text: 'Rejected',
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 500,
//             child: TabBarView(
//               children: [
//                 ListView.builder(
//                   itemCount: 1, 
//                   itemBuilder: (context, index) {
//                     return BookingCard(
//                       propertyType: 'Dorm',
//                       userName: 'User ${index + 1}',
//                       price: '\₱100',
//                       status: 'Pending',  
//                       onApprove: () {
//                         print('Approved booking for User ${index + 1}');
//                       },
//                       onReject: () {
//                         print('Rejected booking for User ${index + 1}');
//                       },
//                     );
//                   },
//                 ),
               
//                 ListView.builder(
//                   itemCount: 2, 
//                   itemBuilder: (context, index) {
//                     return BookingCard(
//                       propertyType: 'Dorm',
//                       userName: 'Approved User ${index + 1}',
//                       price: '\₱150',
//                       status: 'Paid', 
//                       onApprove: null, 
//                       onReject: () {
//                         print('Rejected booking for Approved User ${index + 1}');
//                       },
//                     );
//                   },
//                 ),
              
//                 ListView.builder(
//                   itemCount: 1,
//                   itemBuilder: (context, index) {
//                     return BookingCard(
//                       propertyType: 'Dorm',
//                       userName: 'Rejected User ${index + 1}',
//                       price: '\₱80',
//                       status: 'Rejected', 
//                       onApprove: () {
//                         print('Approved booking for Rejected User ${index + 1}');
//                       },
//                       onReject: null, 
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:unilodge/presentation/widgets/listing/booking_card.dart';

class BookingManagementWidget extends StatelessWidget {
  final List<Map<String, dynamic>> bookingsData; // Accept a list of booking data

  const BookingManagementWidget({super.key, required this.bookingsData});

  @override
  Widget build(BuildContext context) {
    // Separate bookings based on their status
    final pendingBookings = bookingsData
        .where((booking) => booking['status'] == 'Pending')
        .toList();

    final approvedBookings = bookingsData
        .where((booking) => booking['status'] == 'Approved')
        .toList();

    final rejectedBookings = bookingsData
        .where((booking) => booking['status'] == 'Rejected')
        .toList();

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
              Tab(
                icon: Icon(Icons.pending),
                text: 'Pending',
              ),
              Tab(
                icon: Icon(Icons.check_circle),
                text: 'Approved',
              ),
              Tab(
                icon: Icon(Icons.cancel),
                text: 'Rejected',
              ),
            ],
          ),
          SizedBox(
            height: 500,
            child: TabBarView(
              children: [
                // Pending Bookings Tab
                ListView.builder(
                  itemCount: pendingBookings.length,
                  itemBuilder: (context, index) {
                    final booking = pendingBookings[index];
                    return BookingCard(
                      propertyType: booking['propertyType'],
                      userName: booking['userName'],
                      price: booking['price'],
                      status: booking['status'],
                      onApprove: () {
                        // Handle approval logic here
                        print('Approved booking for ${booking['userName']}');
                      },
                      onReject: () {
                        // Handle rejection logic here
                        print('Rejected booking for ${booking['userName']}');
                      },
                    );
                  },
                ),

                // Approved Bookings Tab
                ListView.builder(
                  itemCount: approvedBookings.length,
                  itemBuilder: (context, index) {
                    final booking = approvedBookings[index];
                    return BookingCard(
                      propertyType: booking['propertyType'],
                      userName: booking['userName'],
                      price: booking['price'],
                      status: booking['status'],
                      onApprove: null, // Approved bookings can't be approved again
                      onReject: () {
                        // Handle rejection if you allow reverting approval
                        print('Rejected approved booking for ${booking['userName']}');
                      },
                    );
                  },
                ),

                // Rejected Bookings Tab
                ListView.builder(
                  itemCount: rejectedBookings.length,
                  itemBuilder: (context, index) {
                    final booking = rejectedBookings[index];
                    return BookingCard(
                      propertyType: booking['propertyType'],
                      userName: booking['userName'],
                      price: booking['price'],
                      status: booking['status'],
                      onApprove: () {
                        // Handle approval if you allow reverting rejection
                        print('Approved rejected booking for ${booking['userName']}');
                      },
                      onReject: null, // Rejected bookings can't be rejected again
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
