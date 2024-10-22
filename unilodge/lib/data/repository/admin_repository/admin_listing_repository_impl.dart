import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/data/models/user_profile.dart';
import 'package:unilodge/data/repository/admin_repository/admin_listing_repository.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/admin";

class AdminListingRepositoryImpl implements AdminListingRepository {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<List<Listing>> adminFetchListings() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    final response = await http.get(
      Uri.parse('$_apiUrl/get-dorms'),
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
  Future<List<Listing>> adminFetchUserListings(String user_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    final response = await http.get(
      Uri.parse('$_apiUrl/get-dorms/$user_id'),
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
  Future<List<UserProfileModel>> adminFetchUsers() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    final response = await http.get(
      Uri.parse('$_apiUrl/get-users'),
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
        return data.map((json) => UserProfileModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users');
    }
  }

  @override
  Future<bool> approveListing(String id) async {
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
  Future<bool> declineListing(String id) async {
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
