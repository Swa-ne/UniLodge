import 'package:flutter/material.dart';

class listingPage extends StatefulWidget {
  const listingPage({super.key});

  @override
  State<listingPage> createState() => _listingPageState();
}

class _listingPageState extends State<listingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff83a2ac),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            stops: [0.00, 0.18, 0.90],
          ),
        ),
      )

    );
  }
}