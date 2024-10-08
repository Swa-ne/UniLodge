import 'dart:convert'; // Import for JSON decoding
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/data/models/listing.dart';

final _apiUrl = "${dotenv.env['API_URL']}/listing";

abstract class ListingRepo {
  Future<void> uploadimageurlWithData(
      List<File> imageFiles, Listing dorm); // Updated to use Listing
}

class ListingRepoImpl extends ListingRepo {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<void> uploadimageurlWithData(
      List<File> imageFiles, Listing dorm) async {
    print("API URL: $_apiUrl");
    print(
        "Received listing data: ${dorm.toJson()}"); // Assuming toJson method exists
    print(
        "Received image files: ${imageFiles.map((file) => file.path).toList()}");

    final request =
        http.MultipartRequest('POST', Uri.parse("$_apiUrl/post-dorm"));

    final token = await _tokenController.getAccessToken();
    request.headers['Authorization'] = token;

    for (int i = 0; i < imageFiles.length; i++) {
      File imageFile = imageFiles[i];

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    // Add fields from Listing
    request.fields['property_name'] = dorm.property_name ?? '';
    request.fields['address'] = dorm.address ?? '';
    request.fields['price'] = dorm.price ?? '';
    request.fields['city'] = dorm.city ?? '';
    request.fields['street'] = dorm.street ?? '';
    request.fields['barangay'] = dorm.barangay ?? '';
    request.fields['zipcode'] = dorm.zip_code ?? '';
    request.fields['description'] = dorm.description ?? '';
    request.fields['leaseTerms'] = dorm.leastTerms ?? '';
    request.fields['ownerInfo'] = dorm.ownerInfo ?? '';
    request.fields['rating'] = dorm.rating?.toString() ?? '';
    request.fields['selectedPropertyType'] = dorm.selectedPropertyType ?? '';
    request.fields['amenities'] = dorm.amenities?.join(',') ?? '';
    request.fields['utilities'] = dorm.utilities?.join(',') ?? '';
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("Request headers: ${request.headers}");
    print("Request fields: ${request.fields}");

    if (response.statusCode == 200) {
      print('Image URL and data uploaded successfully');
    } else {
      print(
          'Failed to upload. Status code: ${response.statusCode}, Body: ${json.decode(response.body)}');
    }
  }
}
