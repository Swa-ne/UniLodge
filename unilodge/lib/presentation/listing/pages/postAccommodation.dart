import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/presentation/listing/widgets/customcard.dart';

class PostAccommodation extends StatefulWidget {
  const PostAccommodation({super.key});

  @override
  State<PostAccommodation> createState() => _PostAccommodationState();
}

class _PostAccommodationState extends State<PostAccommodation> {
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
             const Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 70,
                    left: 16,
                    child: Text(
                      'What type of property do you want to list?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 180,
                    left: 16,
                    right: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCard(
                          leading: Icon(Icons.bed, size: 90),
                          leadingWidth: 50,
                          leadingHeight: 80,
                          cardName: 'Bed Spacer',
                          description:
                              'Room shared with one or more occupants, ideal for cost-saving.',
                        ),
                        CustomCard(
                          leading: Icon(Icons.bed, size: 90),
                          leadingWidth: 50,
                          leadingHeight: 80,
                          cardName: 'Private Room',
                          description:
                              'Private Room, basic space for sleeping and studying.',
                        ),
                        CustomCard(
                          leading: Icon(Icons.bed, size: 90),
                          leadingWidth: 50,
                          leadingHeight: 80,
                          cardName: 'Entire Place',
                          description:
                              'Larger space with separate bedrooms, kitchen, and living area.',
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Nav
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, //
                  borderRadius: BorderRadius.horizontal(),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      child: const Text("Back"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.black, width: 1),
                        minimumSize: Size(120, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/post-location');
                      },
                      child: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xff2E3E4A),
                        minimumSize: Size(120, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
