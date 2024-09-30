import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _apiUrl = "${dotenv.env['API_URL']}/authentication";

abstract class AuthFirebaseRepo {
  Future<GoogleSignInAccount?> signInWithGoogle();
  Future<GoogleSignInAccount?> logoutWithGoogle();
}

class AuthFirebaseRepoImpl extends AuthFirebaseRepo {
  static final _googleSignIn = GoogleSignIn();
  @override
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      // TODO: SHOW SIGN IN FAILED
      return null;
    }
    var response = await http.post(
      Uri.parse("$_apiUrl/check-email"),
      body: {'personal_email': googleUser.email},
    );

    if (response.statusCode != 200) {
      // TODO: SHOW EMAIL ALREADY HAS AN ACCOUNT
      logoutWithGoogle();
      return null;
    }
    return googleUser;
  }

  @override
  Future<GoogleSignInAccount?> logoutWithGoogle() async =>
      await _googleSignIn.disconnect();
}
