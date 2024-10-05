import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenController {
  Future<void> updateRefreshToken(String token);
  Future<void> updateAccessToken(String token);
  Future<void> removeRefreshToken();
  Future<void> removeAccessToken();
  Future<String> getRefreshToken();
  Future<String> getAccessToken();
  String? extractRefreshToken(String refresh_token);
}

class TokenControllerImpl extends TokenController {
  static final TokenControllerImpl _instance = TokenControllerImpl._internal();

  factory TokenControllerImpl() {
    return _instance;
  }

  TokenControllerImpl._internal();
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> updateRefreshToken(String token) async {
    await _storage.write(key: "Refresh Token", value: token);
  }

  @override
  Future<void> updateAccessToken(String token) async {
    await _storage.write(key: "Access Token", value: token);
  }

  @override
  Future<void> removeRefreshToken() async {
    await _storage.delete(key: "Refresh Token");
  }

  @override
  Future<void> removeAccessToken() async {
    await _storage.delete(key: "Access Token");
  }

  @override
  Future<String> getRefreshToken() async {
    return await _storage.read(key: "Refresh Token") ?? "";
  }

  @override
  Future<String> getAccessToken() async {
    return await _storage.read(key: "Access Token") ?? "";
  }

  @override
  String? extractRefreshToken(String cookie_header) {
    if (cookie_header.contains('refresh_token=')) {
      final refreshTokenMatch =
          RegExp(r'refresh_token=([^;]+)').firstMatch(cookie_header);
      return refreshTokenMatch?.group(1);
    }

    return null;
  }
}
