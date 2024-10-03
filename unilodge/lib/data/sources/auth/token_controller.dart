import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenController {
  Future<void> updateRefreshToken(String token);
  Future<void> updateAccessToken(String token);
  Future<void> removeRefreshToken(String token);
  Future<void> removeAccessToken(String token);
  Future<void> getRefreshToken();
  Future<String> getAccessToken();
}

class TokenControllerImpl extends TokenController {
  final _storage = const FlutterSecureStorage();
  String _accessToken = "";

  @override
  Future<void> updateRefreshToken(String token) async {
    await _storage.write(key: "Refresh Token", value: token);
  }

  @override
  Future<void> updateAccessToken(String token) async {
    _accessToken = token;
  }

  @override
  Future<void> removeRefreshToken(String token) async {
    await _storage.delete(key: "Refresh Token");
  }

  Future<void> removeAccessToken(String token) async {
    _accessToken = "";
  }

  @override
  Future<void> getRefreshToken() async {
    await _storage.read(key: "Refresh Token");
  }

  @override
  Future<String> getAccessToken() async {
    return _accessToken;
  }
}
