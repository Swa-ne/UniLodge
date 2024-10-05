import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/data/sources/auth/auth_repo.dart';

final _apiUrl = "${dotenv.env['API_URL']}/authentication";

abstract class AuthFirebaseRepo {
  Future<GoogleSignInAccount?> signUpWithGoogle();
  Future<GoogleSignInAccount?> loginWithGoogle();
  Future<GoogleSignInAccount?> logoutWithGoogle();
}

class AuthFirebaseRepoImpl extends AuthFirebaseRepo {
  static final _googleSignIn = GoogleSignIn();
  static final _authRepo = AuthRepoImpl();
  @override
  Future<GoogleSignInAccount?> signUpWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    logoutWithGoogle();

    if (googleUser == null) {
      return null;
    }

    var isEmailAvailable =
        await _authRepo.checkEmailAvalability(googleUser.email);

    if (!isEmailAvailable) {
      return null;
    }
    return googleUser;
  }

  @override
  Future<GoogleSignInAccount?> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    logoutWithGoogle();

    if (googleUser == null) {
      return null;
    }

    return googleUser;
  }

  @override
  Future<GoogleSignInAccount?> logoutWithGoogle() async =>
      await _googleSignIn.disconnect();
}
