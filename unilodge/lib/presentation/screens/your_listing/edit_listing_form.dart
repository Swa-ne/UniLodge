import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/listing/listing_bloc.dart';
import 'package:unilodge/bloc/listing/listing_event.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/common/widgets/custom_confirm_dialog.dart';
import 'package:unilodge/core/configs/assets/app_images.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/listing/multiple_images.dart';
import 'package:unilodge/presentation/widgets/your_listing/edit_listing_text_form_field.dart';
import 'package:unilodge/presentation/widgets/your_listing/property_card.dart';

class EditListingForm extends StatefulWidget {
  final Listing listing;
  const EditListingForm({super.key, required this.listing});

  @override
  State<EditListingForm> createState() => _EditListingFormState();
}

class _EditListingFormState extends State<EditListingForm> {
  late TextEditingController _propertyName;
  late TextEditingController _propertyCity;
  late TextEditingController _propertyStreet;
  late TextEditingController _propertyBarangay;
  late TextEditingController _propertyHouseNumber;
  late TextEditingController _propertyProvince;
  late TextEditingController _propertyRegion;
  late TextEditingController _propertyPrice;
  late TextEditingController _propertyWalletAddress;
  late TextEditingController _propertyDescription;
  late TextEditingController _propertyLeaseTerms;
  late ListingBloc _listingBloc;
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  int _currentStep = 0;
  String _selectedPropertyType = '';
  List<File> selectedImages = [];
  List<String> oldImages = [];

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

  @override
  void initState() {
    super.initState();

    _listingBloc = BlocProvider.of<ListingBloc>(context);
    _propertyName = TextEditingController(text: widget.listing.property_name);
    _propertyCity = TextEditingController(text: widget.listing.city);
    _propertyStreet = TextEditingController(text: widget.listing.street);
    _propertyBarangay = TextEditingController(text: widget.listing.barangay);
    _propertyHouseNumber =
        TextEditingController(text: widget.listing.house_number);
    _propertyProvince = TextEditingController(text: widget.listing.province);
    _propertyRegion = TextEditingController(text: widget.listing.region);
    _propertyPrice = TextEditingController(text: widget.listing.price);
    _propertyWalletAddress =
        TextEditingController(text: widget.listing.walletAddress);
    _propertyDescription =
        TextEditingController(text: widget.listing.description);
    _propertyLeaseTerms =
        TextEditingController(text: widget.listing.leastTerms);
    oldImages = List<String>.from(widget.listing.imageUrl ?? [""]);
  }

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
          style: const TextStyle(color: AppColors.primary, fontSize: 16),
        ),
        const SizedBox(height: 5),
        ...options.keys.map((key) {
          return CheckboxListTile(
            title: Text(
              key,
              style: const TextStyle(color: AppColors.textColor),
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

  Widget _buildPropertySelection() {
    return Column(
      children: [
        PropertyCard(
          imageIcon: AppImages.dormListing,
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
          imageIcon: AppImages.bedspacerListing,
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
          imageIcon: AppImages.soloroomListing,
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
          imageIcon: AppImages.apartmentListing,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final listingBloc = BlocProvider.of<ListingBloc>(context);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.primary,
        ),
      ),
      child: Stepper(
        steps: getSteps(),
        currentStep: _currentStep,
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_selectedPropertyType.isEmpty) {
              return;
            }
          }
          if (_currentStep == 1 && !_formKey2.currentState!.validate()) {
            return;
          }
          if (_currentStep == 2 && !_formKey3.currentState!.validate()) {
            return;
          }
          final isLastStep = _currentStep == getSteps().length - 1;
          if (isLastStep) {
            if (selectedImages.length < 6 && selectedImages.isNotEmpty) {
              return;
            }
            final updatedListing = widget.listing.copyWith(
              selectedPropertyType: _selectedPropertyType,
              property_name: _propertyName.text,
              city: _propertyCity.text,
              street: _propertyStreet.text,
              barangay: _propertyBarangay.text,
              house_number: _propertyHouseNumber.text,
              province: _propertyProvince.text,
              region: _propertyRegion.text,
              price: _propertyPrice.text,
              walletAddress: _propertyWalletAddress.text,
              description: _propertyDescription.text,
              leastTerms: _propertyLeaseTerms.text,
              amenities: _getSelectedAmenities(),
              utilities: _getSelectedUtilities(),
            );

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ConfirmationDialog(
                  title: "Update Listing",
                  content: "Would you like to save changes?",
                  onConfirm: () {
                    _listingBloc.add(UpdateListing(
                      widget.listing.id!,
                      selectedImages,
                      updatedListing,
                    ));
                    listingBloc.add(FetchListings());
                    context.go("/listings");
                  },
                  onCancel: () {
                  },
                  yesButtonColor: AppColors.primary,
                );
              },
            );
          } else {
            setState(() {
              _currentStep++;
            });
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails controls) {
          return Row(
            children: <Widget>[
              TextButton(
                onPressed: controls.onStepCancel,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Back'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: controls.onStepContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.lightBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
        title: const Text(
          'Property Type',
          style:
              TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
        content: Column(
          children: [
            const SizedBox(height: 10),
            _buildPropertySelection(),
            const SizedBox(height: 10),
          ],
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text(
          'Property Information',
          style:
              TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
        content: Form(
          key: _formKey2,
          child: Column(
            children: [
              const SizedBox(height: 10),
              EditListingTextFormField(
                label: "Property Name",
                controller: _propertyName,
              ),
              const SizedBox(height: 20),
              EditListingTextFormField(
                label: "Region",
                controller: _propertyRegion,
              ),
              const SizedBox(height: 20),
              EditListingTextFormField(
                label: "Province",
                controller: _propertyProvince,
              ),
              const SizedBox(height: 20),
              EditListingTextFormField(
                label: "City",
                controller: _propertyCity,
              ),
              const SizedBox(height: 20),
              EditListingTextFormField(
                label: "Barangay",
                controller: _propertyBarangay,
              ),
              const SizedBox(height: 20),
              EditListingTextFormField(
                label: "House Number",
                controller: _propertyHouseNumber,
              ),
              const SizedBox(height: 20),
              EditListingTextFormField(
                label: "Street",
                controller: _propertyStreet,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text(
          'Property Details',
          style:
              TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
        content: Form(
          key: _formKey3,
          child: Column(
            children: [
              const SizedBox(height: 20),
              EditListingTextFormField(
                label: "Price",
                controller: _propertyPrice,
              ),
              const SizedBox(height: 20),
              EditListingTextFormField(
                label: "Wallet Address",
                controller: _propertyWalletAddress,
              ),
              const SizedBox(height: 20),
              EditListingTextFormField(
                label: "Description",
                controller: _propertyDescription,
                minLines: 5,
                maxLines: 10,
              ),
              const SizedBox(height: 20),
              EditListingTextFormField(
                label: "Lease Terms",
                controller: _propertyLeaseTerms,
                minLines: 5,
                maxLines: 10,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text(
          'Facilities',
          style:
              TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
        content: Column(
          children: [
            const SizedBox(height: 10),
            _buildCheckboxSection('Rental Amenities', rentalAmenities),
            _buildCheckboxSection(
                'Utility Included in Rent', utilitiesIncluded),
          ],
        ),
        isActive: _currentStep >= 3,
        state: _currentStep == 3 ? StepState.indexed : StepState.indexed,
      ),
      Step(
        title: const Text(
          'Edit property images',
          style:
              TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Add property images',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Upload at least 6 images',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            MultipleImages(
              onImagesSelected: (images) {
                setState(() {
                  selectedImages = images;
                });
              },
            ),
            if (selectedImages.isEmpty)
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: oldImages.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  String image = oldImages[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
          ],
        ),
        isActive: _currentStep >= 4,
        state: _currentStep == 4 ? StepState.indexed : StepState.indexed,
      ),
    ];
  }
}
