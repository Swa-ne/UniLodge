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
    request.fields['description'] = dorm.description ?? '';
    request.fields['leaseTerms'] = dorm.leaseTerms ?? '';
    request.fields['ownerInfo'] = dorm.ownerInfo ?? '';
    request.fields['imageurl'] = dorm.imageUrl ?? '';
    request.fields['rating'] = dorm.rating?.toString() ?? '';
    request.fields['selectedPropertyType'] = dorm.selectedPropertyType ?? '';

    request.fields['amenities'] = dorm.amenities?.join(',') ?? '';
    request.fields['utilities'] = dorm.utilities?.join(',') ?? '';

    final response = await request.send();

    if (response.statusCode == 200) {
      print('imageurl and data uploaded successfully');
    } else {
      print('Failed to upload imageurl. Status code: ${response.statusCode}');
    }
  }
}
