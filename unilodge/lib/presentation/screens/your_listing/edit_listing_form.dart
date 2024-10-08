import 'package:flutter/material.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/presentation/widgets/your_listing/edit_listing_text_form_field.dart';
import 'package:unilodge/presentation/widgets/your_listing/property_card.dart';

class EditListingForm extends StatefulWidget {
  final Listing listing;
  const EditListingForm({super.key, required this.listing});

  @override
  State<EditListingForm> createState() => _EditListingFormState();
}

class _EditListingFormState extends State<EditListingForm> {
  final _propertyName = TextEditingController();
  final _propertyCity = TextEditingController();
  final _propertyStreet = TextEditingController();
  final _propertyBarangay = TextEditingController();
  final _propertyHouseNumber = TextEditingController();
  final _propertyZipCode = TextEditingController();
  final _propertyPrice = TextEditingController();
  final _propertyDescription = TextEditingController();
  final _propertyLeaseTerms = TextEditingController();

  int _currentStep = 0;
  String _selectedPropertyType = '';

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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
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
          final isLastStep = _currentStep == getSteps().length - 1;
          if (isLastStep) {
            final updatedListing = widget.listing.copyWith(
              selectedPropertyType: _selectedPropertyType,
              property_name: _propertyName.text,
              city: _propertyCity.text,
              street: _propertyStreet.text,
              barangay: _propertyBarangay.text,
              house_number: _propertyHouseNumber.text,
              zip_code: _propertyZipCode.text,
              price: _propertyPrice.text,
              description: _propertyDescription.text,
              leastTerms: _propertyLeaseTerms.text,
              amenities: _getSelectedAmenities(),
              utilities: _getSelectedUtilities(),
            );

            print(updatedListing.selectedPropertyType);
            print(updatedListing.property_name);
            print(updatedListing.city);
            print(updatedListing.street);
            print(updatedListing.barangay);
            print(updatedListing.house_number);
            print(updatedListing.zip_code);
            print(updatedListing.price);
            print(updatedListing.description);
            print(updatedListing.leastTerms);
            print(updatedListing.amenities);
            print(updatedListing.utilities);

            // todo: save

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Update Listing"),
                  content: const Text("Would you like to save changes?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // todo: saveee
                      },
                      child: const Text("Save"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
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
                child: const Text('Back'),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: controls.onStepContinue,
                child: const Text('Continue'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.lightBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
        content: Column(
          children: [
            const SizedBox(height: 10),
            EditListingTextFormField(
                label: "Property Name", controller: _propertyName),
            const SizedBox(height: 20),
            EditListingTextFormField(label: "City", controller: _propertyCity),
            const SizedBox(height: 20),
            EditListingTextFormField(
                label: "Street", controller: _propertyStreet),
            const SizedBox(height: 20),
            EditListingTextFormField(
                label: "Barangay", controller: _propertyBarangay),
            const SizedBox(height: 20),
            EditListingTextFormField(
                label: "House Number", controller: _propertyHouseNumber),
            const SizedBox(height: 20),
            EditListingTextFormField(
                label: "Zip Code", controller: _propertyZipCode),
            const SizedBox(height: 10),
          ],
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
        content: Column(
          children: [
            const SizedBox(height: 20),
            EditListingTextFormField(
                label: "Price", controller: _propertyPrice),
            const SizedBox(height: 20),
            EditListingTextFormField(
                label: "Description", controller: _propertyDescription),
            const SizedBox(height: 20),
            EditListingTextFormField(
                label: "Lease Terms", controller: _propertyLeaseTerms),
            const SizedBox(height: 10),
          ],
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

      // todo: add step for images
    ];
  }
}
