import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/data/repository/listing_repository.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/listing";

class ListingRepositoryImpl implements ListingRepository {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<List<Listing>> fetchListings() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    final response = await http.get(
      Uri.parse('$_apiUrl/my-dorms'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['message'];
        return data.map((json) => Listing.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load listings');
      }
    } catch (e) {
      throw Exception('Failed to load listings');
    }
  }

  @override
  Future<bool> createListing(List<File> imageFiles, Listing dorm) async {
    final request =
        http.MultipartRequest('POST', Uri.parse("$_apiUrl/post-dorm"));

    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    request.headers['Authorization'] = access_token;
    request.headers['Cookie'] = 'refresh_token=$refresh_token';

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

    request.fields['property_name'] = dorm.property_name ?? '';
    request.fields['type'] = dorm.selectedPropertyType ?? '';
    request.fields['city'] = dorm.city ?? '';
    request.fields['street'] = dorm.street ?? '';
    request.fields['barangay'] = dorm.barangay ?? '';
    request.fields['house_number'] = dorm.house_number ?? '';
    request.fields['zip_code'] = dorm.zip_code ?? '';
    request.fields['price'] = dorm.price ?? '';
    request.fields['description'] = dorm.description ?? '';
    request.fields['leaseTerms'] = dorm.leastTerms ?? '';
    request.fields['rating'] = dorm.rating?.toString() ?? '';
    request.fields['amenities'] = dorm.amenities?.join(',') ?? '';
    request.fields['utilities'] = dorm.utilities?.join(',') ?? '';
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 200;
  }

  @override
  Future<void> updateListing(String id, Listing listing) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/edit-dorm/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(listing.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update listing');
    }
  }

  @override
  Future<void> deleteListing(String id) async {
    final response = await http.delete(Uri.parse('$_apiUrl/listing/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete listing');
    }
  }

  @override
  Future<void> toggleListing(String id) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/toggle-visibility/$id'),
    );

    if (response.statusCode != 200) {
      final errorResponse = jsonDecode(response.body);
      throw Exception('Failed to update listing: ${errorResponse['error']}');
    }
  }
}
