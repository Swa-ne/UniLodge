import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/presentation/post/widgets/customcard.dart';

class PostAccommodation extends StatefulWidget {
  const PostAccommodation({super.key});

  @override
  State<PostAccommodation> createState() => _PostAccommodationState();
}

class _PostAccommodationState extends State<PostAccommodation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 60,
                  left: 16,
                  child: Text(
                    'What type of property do you want to list?',
                    style: TextStyle(
                      color: AppColors.primary,
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
                        leading: Icon(
                          Icons.bed,
                          size: 90,
                          color: AppColors.primary,
                        ),
                        leadingWidth: 50,
                        leadingHeight: 80,
                        cardName: 'Bed Spacer',
                        description:
                            'Room shared with one or more occupants, ideal for cost-saving.',
                      ),
                      CustomCard(
                        leading: Icon(
                          Icons.bed,
                          size: 90,
                          color: AppColors.primary,
                        ),
                        leadingWidth: 50,
                        leadingHeight: 80,
                        cardName: 'Private Room',
                        description:
                            'Private Room, basic space for sleeping and studying.',
                      ),
                      CustomCard(
                        leading: Icon(
                          Icons.bed,
                          size: 90,
                          color: AppColors.primary,
                        ),
                        leadingWidth: 50,
                        leadingHeight: 80,
                        cardName: 'Entire Place',
                        description:
                            'Larger space with separate bedrooms, kitchen, and living area.',
                      ),
                      const SizedBox(height: 16),
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
                    color: const Color.fromARGB(255, 119, 119, 119)
                        .withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, -1),
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
                      context.go('/listings');
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
                      context.push('/post-location');
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
    );
  }
}
