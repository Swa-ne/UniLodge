import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/data/models/renter.dart';
import 'package:unilodge/data/repository/renter_repository.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/render";

class RenterRepositoryImpl implements RenterRepository {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<List<Listing>> fetchAllDorms() async {
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
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('message')) {
        final List<dynamic> data = responseBody['message'];
        return data.map((json) => Listing.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load dorms');
    }
  }

  @override
  Future<List<SavedDorm>> fetchSavedDorms(String userId) async {
    final response = await http.get(Uri.parse('$_apiUrl/my-dorms'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['savedDorms'];
      return data.map((json) => SavedDorm.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load saved dorms');
    }
  }

  @override
  Future<void> postReview(
      String userId, String dormId, int stars, String comment) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/give-review/$dormId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'dormId': dormId,
        'stars': stars,
        'comment': comment,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to post review');
    }
  }

  @override
  Future<void> saveDorm(String userId, String dormId) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/add/saved'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'dormId': dormId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save dorm');
    }
  }

  @override
  Future<void> deleteSavedDorm(String userId, String dormId) async {
    final response = await http.delete(
      Uri.parse('$_apiUrl/remove/saved'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'dormId': dormId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete saved dorm');
    }
  }
}
