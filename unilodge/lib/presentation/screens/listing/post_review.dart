import 'package:flutter/material.dart';

class Postreview extends StatelessWidget {
  const Postreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("bukas ko na ayusin"),
      ),
      body: const Stack(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ))
        ],
      ),
      
    );
  }
}
