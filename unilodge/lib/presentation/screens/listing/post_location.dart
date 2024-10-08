import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';

class PostLocation extends StatefulWidget {
  final Listing listing;
  const PostLocation({super.key, required this.listing});

  @override
  _PostLocationState createState() => _PostLocationState();
}

class _PostLocationState extends State<PostLocation> {
  final TextEditingController _propertyNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _barangayController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                const Positioned(
                  top: 60,
                  left: 16,
                  child: Text(
                    'Property Information',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Positioned(
                  top: 90,
                  left: 16,
                  right: 16,
                  child: Text(
                    'Please fill in all fields below to continue',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: AppColors.primary),
                  ),
                ),
                const Positioned(
                    top: 20,
                    right: 20,
                    child: Icon(
                      Icons.draw,
                      size: 70,
                      color: AppColors.primary,
                    )),
                Positioned(
                  top: 160,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField2(
                          controller: _propertyNameController,
                          label: 'Property Name',
                          hint: "Enter property name"),
                      _buildTextField2(
                          controller: _cityController,
                          label: 'City',
                          hint: "Enter city"),
                      _buildTextField2(
                          controller: _streetController,
                          label: 'Street',
                          hint: "Enter street"),
                      _buildTextField2(
                          controller: _barangayController,
                          label: 'Barangay',
                          hint: "Enter barangay"),
                      _buildTextField2(
                          controller: _houseNumberController,
                          label: 'House Number',
                          hint: "Enter house number"),
                      _buildTextField2(
                          controller: _zipcodeController,
                          label: 'Zipcode',
                          hint: "Enter zipcode"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(1.0),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                      // Create the combined address
                      final combinedAddress =
                          '${_houseNumberController.text} ${_streetController.text}, ${_barangayController.text}, ${_cityController.text}, ${_zipcodeController.text}';

                      // Update the listing model with the new data, without the 'address' field
                      final updatedListing = widget.listing.copyWith(
                        property_name: _propertyNameController.text,
                        city: _cityController.text,
                        street: _streetController.text,
                        barangay: _barangayController.text,
                        house_number: _houseNumberController.text,
                        zip_code: _zipcodeController.text,
                        address: combinedAddress, // for ui
                      );

                      // Navigate to the next page with the updated listing

                      context.push('/post-price', extra: updatedListing);
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
        ],
      ),
    );
  }

  Widget _buildTextField2({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2E3E4A)),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
