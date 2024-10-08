import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/data/models/login_user.dart';
import 'package:unilodge/data/models/sign_up_user.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/authentication";

abstract class AuthRepo {
  Future<String> login(LoginUserModel user);
  Future<String> signUp(SignUpUserModel user);
  Future<bool> checkEmailAvalability(String email);
  Future<bool> checkUsernameAvalability(String username);
  Future<bool> checkEmailVerified(String token);
  Future<bool> resendEmailCode(String token);
  Future<String> verifyEmail(String token, String code);
  Future<String> forgotPassword(String email);
  Future<bool> postResetPassword(
      String token, String password, String confirmation_password);
  Future<bool> logout();
  Future<bool> authenticateToken();
  Future<String?> getAccessToken();
}

class AuthRepoImpl extends AuthRepo {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<String> login(LoginUserModel user) async {
    var response = await http.post(
      Uri.parse("$_apiUrl/login"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(user.toJson()),
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      _tokenController.updateAccessToken(response_body['access_token']);

      String? cookies = response.headers['set-cookie'];
      if (cookies == null) {
        throw Exception("Server connection error");
      }

      String? refresh_token = _tokenController.extractRefreshToken(cookies);
      if (refresh_token == null) {
        throw Exception("Server connection error");
      }

      _tokenController.updateRefreshToken(refresh_token);
      return response_body['access_token'];
    } else {
      throw Exception(response_body['error']);
    }
  }

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
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> checkEmailAvalability(String email) async {
    final response = await http.post(
      Uri.parse("$_apiUrl/check-email"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(
        {
          'personal_email': email,
        },
      ),
    );

    final response_body = json.decode(response.body);
    if ([200, 404, 409].contains(response.statusCode)) {
      return response_body['message'] == "Success";
    } else {
      throw Exception("Internal Server Error");
    }
  }

  @override
  Future<bool> checkEmailVerified(String token) async {
    final response = await http.post(
      Uri.parse("$_apiUrl/check-email-verification"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );

    final response_body = json.decode(response.body);
    if ([200, 404, 409, 403].contains(response.statusCode)) {
      return response_body['message'] == "Success";
    } else {
      throw Exception("Internal Server Error");
    }
  }

  @override
  Future<bool> checkUsernameAvalability(String username) async {
    final response = await http.post(
      Uri.parse("$_apiUrl/check-username"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(
        {
          'username': username,
        },
      ),
    );

    final response_body = json.decode(response.body);
    if ([200, 404, 409].contains(response.statusCode)) {
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> resendEmailCode(String token) async {
    var response = await http.put(
      Uri.parse("$_apiUrl/resend-verification"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
    if ([200, 404, 401].contains(response.statusCode)) {
      return true;
    } else {
      throw Exception(
          "Too many requests, please wait a while before retrying.");
    }
  }

  @override
  Future<String> verifyEmail(String token, String code) async {
    var response = await http.post(
      Uri.parse("$_apiUrl/verify-code"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: json.encode(
        {
          'code': code,
        },
      ),
    );
    final response_body = json.decode(response.body);
    if (response.statusCode == 200) {
      _tokenController.updateAccessToken(response_body['access_token']);

      String? cookies = response.headers['set-cookie'];
      if (cookies == null) {
        throw Exception("Server connection error");
      }

      String? refresh_token = _tokenController.extractRefreshToken(cookies);
      if (refresh_token == null) {
        throw Exception("Server connection error");
      }

      _tokenController.updateRefreshToken(refresh_token);
      return response_body['access_token'];
    } else {
      throw Exception("Incorrect Verification Code");
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse("$_apiUrl/forgot-password"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(
        {
          'personal_email': email,
        },
      ),
    );
    final response_body = json.decode(response.body);
    if (response.statusCode == 200) {
      return response_body['token'];
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> postResetPassword(
      String token, String password, String confirmation_password) async {
    var response = await http.post(
      Uri.parse("$_apiUrl/reset-password"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: json.encode(
        {
          'password': password,
          'confirmation_password': confirmation_password,
        },
      ),
    );
    final response_body = json.decode(response.body);
    if ([200, 400, 404].contains(response.statusCode)) {
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> logout() async {
    final token = await _tokenController.getAccessToken();
    print('Logging out with token: $token');

    var response = await http.delete(
      Uri.parse("$_apiUrl/logout"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
    final response_body = json.decode(response.body);
    if (response.statusCode == 200) {
      _tokenController.removeAccessToken();
      _tokenController.removeRefreshToken();
      return response_body['message'] == "User logged Out";
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> authenticateToken() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.get(
      Uri.parse("$_apiUrl/current-user"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);
    if (response.statusCode == 200) {
      var newAccessToken = response.headers['authorization'];
      if (newAccessToken != null) {
        var tokenValue = newAccessToken.split(' ')[1];
        await _tokenController.updateAccessToken(tokenValue);
      }
      return true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return await _tokenController.getAccessToken();
  }
}
