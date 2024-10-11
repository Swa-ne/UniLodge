import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:unilodge/core/configs/theme/app_colors.dart';
import 'package:unilodge/data/models/listing.dart';

class PostLocation extends StatefulWidget {
  final String selectedPropertyType;
  const PostLocation({Key? key, required this.selectedPropertyType})
      : super(key: key);

  @override
  _PostLocationState createState() => _PostLocationState();
}

class _PostLocationState extends State<PostLocation> {
  final TextEditingController _propertyNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _barangayController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();

  List<dynamic> allData = [];
  List<String> provinces = [];
  List<String> cities = [];
  List<String> barangays = [];
  @override
  void initState() {
    super.initState();
    loadJsonData();
    _regionController.addListener(_updateProvinces);
    _provinceController.addListener(_updateCities);
    _cityController.addListener(_updateBarangays);
  }

  void _updateProvinces() {
    if (_regionController.text.isNotEmpty) {
      var selectedRegion = allData.firstWhere(
          (region) => region['region_name'] == _regionController.text,
          orElse: () => null);
      if (selectedRegion != null) {
        provinces = selectedRegion['province_list'].keys.toList();
        setState(() {
          _provinceController.text = '';
        });
      }
    }
  }

  void _updateCities() {
    if (_provinceController.text.isNotEmpty) {
      var selectedRegion = allData.firstWhere(
          (region) => region['region_name'] == _regionController.text,
          orElse: () => null);
      if (selectedRegion != null) {
        var selectedProvince =
            selectedRegion['province_list'][_provinceController.text];
        if (selectedProvince != null) {
          cities = selectedProvince['municipality_list'].keys.toList();
          setState(() {
            _cityController.text = '';
          });
        }
      }
    }
  }

  void _updateBarangays() {
    if (_cityController.text.isNotEmpty) {
      var selectedRegion = allData.firstWhere(
          (region) => region['region_name'] == _regionController.text,
          orElse: () => null);
      if (selectedRegion != null) {
        var selectedProvince =
            selectedRegion['province_list'][_provinceController.text];
        if (selectedProvince != null) {
          var selectedCity =
              selectedProvince['municipality_list'][_cityController.text];
          if (selectedCity != null) {
            var barangaysDynamicList =
                selectedCity['barangay_list'] as List<dynamic>;
            barangays =
                barangaysDynamicList.map<String>((e) => e.toString()).toList();
            setState(() {
              _barangayController.text = '';
            });
          }
        }
      }
    }
  }

  void loadJsonData() async {
    final String response =
        await rootBundle.loadString('assets/constant/address.json');
    final data = json.decode(response);
    setState(() {
      allData = data;
    });
  }

  void _showSearchDialog({
    required BuildContext context,
    required List<String> options,
    required TextEditingController controller,
    required String title,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select $title'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: "Search $title",
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          Navigator.of(context).pop();
                          controller.text = option;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    List<String>? options,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: options != null,
        onTap: () {
          if (options != null) {
            _showSearchDialog(
              context: context,
              options: options,
              controller: controller,
              title: label,
            );
          }
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: options != null ? Icon(Icons.arrow_drop_down) : null,
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

  @override
  Widget build(BuildContext context) {
    List<String> regions = allData
        .map<String>((region) => region['region_name'] as String)
        .toList();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        color: AppColors.primary,
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
                      )),
                  _buildTextField(
                      controller: _propertyNameController,
                      label: 'Property Name',
                      hint: "Enter property name"),
                  _buildTextField(
                    controller: _regionController,
                    label: 'Region',
                    hint: "Select region",
                    options: regions,
                  ),
                  _buildTextField(
                      controller: _provinceController,
                      label: 'Province',
                      hint: "Select province",
                      options: provinces),
                  _buildTextField(
                      controller: _cityController,
                      label: 'City',
                      hint: "Select city",
                      options: cities),
                  _buildTextField(
                      controller: _barangayController,
                      label: 'Barangay',
                      hint: "Select barangay",
                      options: barangays),
                  _buildTextField(
                      controller: _houseNumberController,
                      label: 'House Number',
                      hint: "Enter house number"),
                  _buildTextField(
                      controller: _streetController,
                      label: 'Street',
                      hint: "Enter street"),
                ],
              ),
            ),
          ),
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
                      final combinedAddress =
                          '${_houseNumberController.text} ${_streetController.text}, ${_barangayController.text}, ${_cityController.text}, ${_provinceController.text}, ${_regionController.text}';
                      final updatedListing = Listing(
                        selectedPropertyType: widget.selectedPropertyType,
                        property_name: _propertyNameController.text,
                        city: _cityController.text,
                        street: _streetController.text,
                        barangay: _barangayController.text,
                        house_number: _houseNumberController.text,
                        province: _provinceController.text,
                        region: _regionController.text,
                        address: combinedAddress,
                      );
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
                    child: const Text("Next"),
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
