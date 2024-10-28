import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';

class SuccessTransaction extends StatefulWidget {
  const SuccessTransaction(
      {super.key, required this.transactionResult, required this.listing});

  final String transactionResult;
  final Listing listing;

  @override
  State<SuccessTransaction> createState() => _SuccessTransactionState();
}

class _SuccessTransactionState extends State<SuccessTransaction> {
  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.successTransaction,
                    width: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Sent to " + widget.listing.owner_id!.full_name,
                    style: TextStyle(fontSize: 15, color: Color(0xff434343)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 130),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(123, 235, 235, 235),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.ethereum,
                          height: 30,
                        ),
                        Text(widget.listing.price! + " ETH"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(123, 235, 235, 235),
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [
                //   BoxShadow(
                //     color: const Color(0xFF636464).withOpacity(0.1),
                //     offset: const Offset(0, 1),
                //     blurRadius: 10,
                //   ),
                // ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Transaction hash:",
                        style: const TextStyle(
                            fontSize: 15, color: Color(0xff434343))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 3.0, right: 8, top: 8, left: 8),
                    child: Text(widget.transactionResult,
                        style: const TextStyle(
                            fontSize: 15, color: AppColors.formTextColor)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Divider(height: 20, color: AppColors.lightBackground),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 3.0, right: 8, bottom: 8, left: 8),
                    child: Text("Date:",
                        style: const TextStyle(
                            fontSize: 15, color: Color(0xff434343))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$currentDate',
                        style: const TextStyle(
                            fontSize: 15, color: AppColors.formTextColor)),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home'); // Navigate back to home
                },
                child: const Text('Okay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.lightBackground,
                  minimumSize: Size(double.infinity, 50), // Full width
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
