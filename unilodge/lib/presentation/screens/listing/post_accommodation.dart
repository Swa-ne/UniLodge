import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/your_listing/property_card.dart';

class PostAccommodation extends StatefulWidget {
  final Listing listing;

  const PostAccommodation({super.key, required this.listing});

  @override
  State<PostAccommodation> createState() => _PostAccommodationState();
}

class _PostAccommodationState extends State<PostAccommodation> {
  String _selectedPropertyType = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 70),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What type of property do you want to list?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Expanded(
            child: Column(
              children: [
                PropertyCard(
                  cardName: 'Dorm',
                  description:
                      'Shared room with multiple occupants; ideal for students and budget-friendly living.',
                  isSelected: _selectedPropertyType == 'Dorm',
                  onTap: () {
                    setState(() {
                      _selectedPropertyType = 'Dorm';
                    });
                  },
                ),
                PropertyCard(
                  cardName: 'Bed Spacer',
                  description:
                      'Shared room with designated sleeping areas; a cost-effective living option.',
                  isSelected: _selectedPropertyType == 'Bed Spacer',
                  onTap: () {
                    setState(() {
                      _selectedPropertyType = 'Bed Spacer';
                    });
                  },
                ),
                PropertyCard(
                  cardName: 'Solo Room',
                  description:
                      'Private room offering a quiet space for sleeping and studying.',
                  isSelected: _selectedPropertyType == 'Solo Room',
                  onTap: () {
                    setState(() {
                      _selectedPropertyType = 'Solo Room';
                    });
                  },
                ),
                PropertyCard(
                  cardName: 'Apartment',
                  description:
                      'Self-contained unit with separate bedrooms, kitchen, and living area.',
                  isSelected: _selectedPropertyType == 'Apartment',
                  onTap: () {
                    setState(() {
                      _selectedPropertyType = 'Apartment';
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child:
                _BottomNavigation(selectedPropertyType: _selectedPropertyType),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final String selectedPropertyType;

  const _BottomNavigation({required this.selectedPropertyType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.horizontal(),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: () {
              context.go('/home');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: Colors.black, width: 1),
              minimumSize: const Size(120, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Back"),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: selectedPropertyType.isNotEmpty
                ? () {
                    context.push('/post-location', extra: selectedPropertyType);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xff2E3E4A),
              minimumSize: const Size(120, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
