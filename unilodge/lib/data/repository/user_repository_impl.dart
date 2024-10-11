import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:unilodge/data/models/user_profile.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';
import 'user_repository.dart';

final _apiUrl = "${dotenv.env['API_URL']}/authentication";

class UserRepositoryImpl implements UserRepository {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<UserProfileModel> fetchCurrentUser() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    final response = await http.get(
      Uri.parse('$_apiUrl/current-user'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );

    print('fetchCurrentUser response status: ${response.statusCode}');
    print('fetchCurrentUser response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('message')) {
        final Map<String, dynamic> data = responseBody['message'];
        return UserProfileModel.fromJson(data);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      print('Error: ${response.statusCode}, ${response.reasonPhrase}');
      throw Exception('Failed to load user data: ${response.body}');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileModel user) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    final response = await http.put(
      Uri.parse('$_apiUrl/edit-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
      body: json.encode(user.toJson()), 
    );

    print('updateUserProfile response status: ${response.statusCode}');
    print('updateUserProfile response body: ${response.body}');

    if (response.statusCode != 200) {
      print('Error: ${response.statusCode}, ${response.reasonPhrase}');
      throw Exception('Failed to update user profile: ${response.body}');
    }
  }
}
