import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessTransaction extends StatefulWidget {
  const SuccessTransaction({super.key});

  @override
  State<SuccessTransaction> createState() => _SuccessTransactionState();
}

class _SuccessTransactionState extends State<SuccessTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Center(
       child: Container(
        child: Text("Success"),
      ), 
      ),
    );
  }
}