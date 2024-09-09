import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/presentation/Post/Widgets/customcard.dart';

class Postaccommodation extends StatefulWidget {
  const Postaccommodation({super.key});

  @override
  State<Postaccommodation> createState() => _PostaccommodationState();
}

class _PostaccommodationState extends State<Postaccommodation> {
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
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 16,
                    child: Text(
                      'What type of property do you want to list?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 140,
                    left: 16,
                    right: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCard(
                          cardName: 'BedSpacer',
                          description:
                              'A small area for a bed, ideal for budget accommodation.',
                        ),
                        CustomCard(
                          cardName: 'Private Room',
                          description: 'A room with a single bed or bunk beds.',
                        ),
                        CustomCard(
                          cardName: 'Private Room',
                          description: 'A room with a single bed or bunk beds.',
                        ),
                        CustomCard(
                          cardName: 'Private Room',
                          description: 'A room with a single bed or bunk beds.',
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Back"),
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xfffdfdfd),
                      backgroundColor: Color(0xff2E3E4A),
                      minimumSize: Size(170, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Next'),
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xfffdfdfd),
                      backgroundColor: Color(0xff2E3E4A),
                      minimumSize: Size(170, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
