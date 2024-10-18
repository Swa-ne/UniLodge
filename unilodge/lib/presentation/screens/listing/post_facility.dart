import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart'; 


class PostFacility extends StatefulWidget {
  const PostFacility({super.key, required this.listing});
  final Listing listing;

  @override
  _PostFacilityState createState() => _PostFacilityState();
}

class _PostFacilityState extends State<PostFacility> {
  Map<String, bool> rentalAmenities = {
    'Internet': false,
    'Air conditioned': false,
    'Washing Machine': false,
    'Furniture': false,
    'Kitchen': false,
    'TV': false,
    'Washroom': false,
    'First Aid Kit': false,
  };

  Map<String, bool> utilitiesIncluded = {
    'Electric': false,
    'Water': false,
    'Gas': false,
    'Internet': false,
  };

  List<String> _getSelectedAmenities() {
    return rentalAmenities.entries
        .where((element) => element.value == true)
        .map((e) => e.key)
        .toList();
  }

  List<String> _getSelectedUtilities() {
    return utilitiesIncluded.entries
        .where((element) => element.value == true)
        .map((e) => e.key)
        .toList();
  }

  Widget _buildCheckboxSection(String title, Map<String, bool> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 5),
        ...options.keys.map((key) {
          return CheckboxListTile(
            title: Text(
              key,
              style: const TextStyle(fontSize: 14),
            ),
            value: options[key],
            activeColor: AppColors.primary,
            onChanged: (bool? value) {
              setState(() {
                options[key] = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textColor),
            onPressed: () {
              context.push("/listings");
            },
          )),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),
                const Text(
                  'Facilities in your Dorm',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const SizedBox(height: 10),
                _buildCheckboxSection('Rental Amenities', rentalAmenities),
                _buildCheckboxSection('Utility Included in rent', utilitiesIncluded),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.horizontal(),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 119, 119, 119)
                        .withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.pop();
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
                    onPressed: () {
                      // Update the listing object with the selected amenities and utilities
                      final updatedListing = widget.listing.copyWith(
                        amenities: _getSelectedAmenities(),
                        utilities: _getSelectedUtilities(),
                      );
                      
                      context.push('/post-image', extra: updatedListing);
                    },
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
            ),
          ),
          const Positioned(
            top: 20,
            right: 20,
            child: Icon(
              Icons.draw,
              size: 70,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
