import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/data/admin_repository/admin_listing_repository.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/listing";
final _apiUrlRenter = "${dotenv.env['API_URL']}/render";

class AdminListingRepositoryImpl implements AdminListingRepository {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<List<Listing>> adminFetchListings() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    final response = await http.get(
      Uri.parse('$_apiUrlRenter/my-dorms'),
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


  // @override
  // Future<bool> toggleListing(String id) async {
  //   final access_token = await _tokenController.getAccessToken();
  //   final refresh_token = await _tokenController.getRefreshToken();
  //   final response = await http.put(
  //     Uri.parse('$_apiUrl/toggle-visibility/$id'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': access_token,
  //       'Cookie': 'refresh_token=$refresh_token',
  //     },
  //   );

  //   if (response.statusCode != 200) {
  //     final errorResponse = jsonDecode(response.body);
  //     throw Exception('Failed to update listing: ${errorResponse['error']}');
  //   }
  //   return response.statusCode == 200;
  // }

  @override
  Future<bool> acceptListing(String id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    final response = await http.put(
      Uri.parse('$_apiUrl/approve-listing/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to accept listing');
    }
    return response.statusCode == 200;
  }

  @override
  Future<bool> rejectListing(String id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    final response = await http.put(
      Uri.parse('$_apiUrl/decline-listing/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reject listing');
    }
    return response.statusCode == 200;
  }

}
