import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unilodge/data/models/user.dart';

abstract class AuthFirebaseService {
  Future<GoogleSignInAccount?> signInWithGoogle();
  Future<GoogleSignInAccount?> logoutWithGoogle();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  static final _googleSignIn = GoogleSignIn();
  @override
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      // TODO: SHOW SIGN IN FAILED
      print("Login Failed");
      return null;
    }
    return googleUser;
  }

  @override
  Future<GoogleSignInAccount?> logoutWithGoogle() async =>
      await _googleSignIn.disconnect();
}
