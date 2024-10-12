import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/listing/mixin/listing_validation.dart';

class PostPrice extends StatefulWidget {
  final Listing listing;

  const PostPrice({super.key, required this.listing});

  @override
  _PostPriceState createState() => _PostPriceState();
}

class _PostPriceState extends State<PostPrice> with InputValidationMixin {
  final _formKey = GlobalKey<FormState>(); // GlobalKey to track form state
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
                  child: Form(
                    key: _formKey, 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 17),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Property Information',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Please fill in all fields below to continue',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17.0),
                                    child: Icon(
                                      Icons.draw,
                                      size: 70,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _buildTextField(
                          controller: _priceController,
                          label: 'Price',
                          hint: 'Enter price',
                          contentPadding: const EdgeInsets.all(16),
                          validator: (value) => validateNumber(value ?? ''),
                        ),
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          hint: 'Enter description',
                          maxLines: 5,
                          minLines: 5,
                          contentPadding: const EdgeInsets.all(16),
                          validator: (value) =>
                              validateDescription(value ?? ''),
                        ),
                        _buildTextField(
                          controller: _leaseTermsController,
                          label: 'Lease Terms',
                          hint: 'Enter lease terms',
                          maxLines: 5,
                          minLines: 5,
                          contentPadding: const EdgeInsets.all(16),
                          validator: (value) => validateLeaseTerms(value ?? ''),
                        ),
                      ],
                    ),
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
                        if (_formKey.currentState!.validate()) {
                          final updatedListing = widget.listing.copyWith(
                            price: _priceController.text,
                            description: _descriptionController.text,
                            leastTerms: _leaseTermsController.text,
                          );
                          context.push('/post-Facility', extra: updatedListing);
                        }
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
        ],
      ),
    );
  }

  // Helper function to build text fields with validation
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    int minLines = 1,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.symmetric(vertical: 16.0),
    String? Function(String?)? validator, // Add validator parameter
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
        validator: validator, // Apply validation here
        keyboardType:
            label == 'Price' ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}
