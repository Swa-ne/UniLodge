import 'package:google_sign_in/google_sign_in.dart';
import 'package:unilodge/data/models/user.dart';

abstract class AuthFirebaseService {
  Future<GoogleSignInAccount?> signInWithGoogle();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // final credential = googleAuth.credential(
    //   accessToken: googleAuth?.accessToken,
    //   idToken: googleAuth?.idToken,
    // );

    // return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
