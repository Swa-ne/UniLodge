import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/data/models/signUpUser.dart';

final _apiUrl = "${dotenv.env['API_URL']}/authentication";

abstract class AuthRepo {
  Future<String> signUp(SignUpUserModel user);
}

class AuthRepoImpl extends AuthRepo {
  @override
  Future<String> signUp(SignUpUserModel user) async {
    var response = await http.post(
      Uri.parse("$_apiUrl/signup"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(user.toJson()),
    );
    final response_body = json.decode(response.body);
    if (response.statusCode == 200) {
      return response_body['access_token'];
    } else {
      // TODO: show error sa mismong textfield
      throw Exception(response_body['error']);
    }
  }
}
