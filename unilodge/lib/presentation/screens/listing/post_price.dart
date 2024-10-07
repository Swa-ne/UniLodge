import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart'; // Import your Listing model

class PostPrice extends StatefulWidget {
  final Listing listing;

  const PostPrice({super.key, required this.listing});

  @override
  _PostPriceState createState() => _PostPriceState();
}

class _PostPriceState extends State<PostPrice> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _leaseTermsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 60),
                      const Text(
                        'Property Information',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Please fill in all fields below to continue',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 50),

                      // // Display the selected property type here
                      // Text(
                      //   'Selected Property Type: ${widget.listing.selectedPropertyType ?? 'N/A'}',
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // Text(
                      //   'Address: ${widget.listing.address ?? 'N/A'}',
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // Text(
                      //   'Property Name: ${widget.listing.property_name ?? "N/A"}',
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),

                      const SizedBox(height: 20), // Add spacing after text

                      // Capture Price input
                      _buildTextField(
                        controller: _priceController,
                        label: 'Price',
                        hint: 'Enter price',
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      // Capture Description input
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Enter description',
                        maxLines: 5,
                        minLines: 5,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      // Capture Least Terms input
                      _buildTextField(
                        controller: _leaseTermsController,
                        label: 'Least Terms',
                        hint: 'Enter least terms',
                        maxLines: 5,
                        minLines: 5,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom buttons
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 1),
                        minimumSize: const Size(120, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Update the listing with the new data from this page
                        final updatedListing = widget.listing.copyWith(
                          price: _priceController.text,
                          description: _descriptionController.text,
                          leaseTerms: _leaseTermsController.text,  
                        );

          
                        context.push('/post-Facility', extra: updatedListing);
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
            ],
          ),
          // Positioned icon at the top-right
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

  // Helper function to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    int minLines = 1,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.symmetric(vertical: 16.0),
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller, // Bind the controller to capture input
        maxLines: maxLines,
        minLines: minLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.blueTextColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(
            color: AppColors.formTextColor,
            height: 1.3,
          ),
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}
