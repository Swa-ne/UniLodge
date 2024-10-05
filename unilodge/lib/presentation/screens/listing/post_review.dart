import 'package:flutter/material.dart';

class Postreview extends StatelessWidget {
  const Postreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("bukas ko na ayusin"),
      ),
      body: Stack(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ))
        ],
      ),
      
    );
  }
}
