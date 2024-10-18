import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/verify";

abstract class VerifyUserRepo {
  Future<String> verifyIdImage(File image);
  Future<String> verifyFaceImage(File image);
  Future<String> verifyUser();
}

class VerifyUserRepoImpl extends VerifyUserRepo {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<String> verifyIdImage(File image) async {
    final request =
        http.MultipartRequest('POST', Uri.parse("$_apiUrl/check-id"));

    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    request.headers['Authorization'] = access_token;
    request.headers['Cookie'] = 'refresh_token=$refresh_token';

    request.files.add(
      http.MultipartFile.fromBytes('file', await image.readAsBytes(),
          filename: image.path, contentType: MediaType('image', 'jpeg')),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    if (response.statusCode == 200) {
      return "Success";
    }
    return json.decode(response.body)['error'];
  }

  @override
  Future<String> verifyFaceImage(File image) async {
    final request =
        http.MultipartRequest('POST', Uri.parse("$_apiUrl/check-face"));

    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    request.headers['Authorization'] = access_token;
    request.headers['Cookie'] = 'refresh_token=$refresh_token';

    request.files.add(
      http.MultipartFile.fromBytes('file', await image.readAsBytes(),
          filename: image.path, contentType: MediaType('image', 'jpeg')),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    if (response.statusCode == 200) {
      return "Success";
    }
    return json.decode(response.body)['error'];
  }

  @override
  Future<String> verifyUser() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    final response = await http.post(
      Uri.parse('$_apiUrl/verify-user'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete listing');
    }
    print(response.body);
    if (response.statusCode == 200) {
      return "Success";
    }
    return json.decode(response.body)['error'];
  }
}
