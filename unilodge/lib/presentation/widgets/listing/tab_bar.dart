import 'package:flutter/material.dart';
import 'package:unilodge/presentation/widgets/listing/booking_card.dart';

class BookingManagementWidget extends StatelessWidget {
  const BookingManagementWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                ListView.builder(
                  itemCount: 1, 
                  itemBuilder: (context, index) {
                    return BookingCard(
                      propertyType: 'Dorm',
                      userName: 'User ${index + 1}',
                      price: '\$100',
                      onApprove: () {
                        print('Approved booking for User ${index + 1}');
                      },
                      onReject: () {
                        print('Rejected booking for User ${index + 1}');
                      },
                    );
                  },
                ),

                ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return BookingCard(
                      propertyType: 'Dorm',
                      userName: 'Approved User ${index + 1}',
                      price: '\$150',
                      onApprove: null, 
                      onReject: () {
                        print('Rejected booking for Approved User ${index + 1}');
                      },
                    );
                  },
                ),


                ListView.builder(
                  itemCount: 1, 
                  itemBuilder: (context, index) {
                    return BookingCard(
                      propertyType: 'Dorm',
                      userName: 'Rejected User ${index + 1}',
                      price: '\$80',
                      onApprove: () {
                        print('Approved booking for Rejected User ${index + 1}');
                      },
                      onReject: null,
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