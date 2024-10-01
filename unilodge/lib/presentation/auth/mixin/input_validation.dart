import 'package:unilodge/data/sources/auth/authRepo.dart';

mixin InputValidationMixin {
  static final _authRepo = AuthRepoImpl();

  String? validateEmail(String email) {
    final RegExp emailRegExp =
        RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$');
    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<String?> validateEmailInUse(String email) async {
    final emailFormatError = validateEmail(email);
    if (emailFormatError != null) {
      return emailFormatError;
    }

    bool isAvailable = await _authRepo.checkEmailAvalability(email);
    if (!isAvailable) {
      return 'This email is already in use';
    }
    return null;
  }

  String? validateName(String name) {
    if (name.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  String? validatePassword(String password) {
    final RegExp passwordRegExp = RegExp(
        r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,}$');

    if (password.isEmpty) {
      return 'Password cannot be empty';
    } else if (!passwordRegExp.hasMatch(password)) {
      return 'Password must contain at least 8 characters, including one uppercase letter, one lowercase letter, one number, and one special character.';
    }
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Confirm password cannot be empty';
    } else if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateUsername(String username) {
    final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    if (username.isEmpty) {
      return 'Username can\'t be empty';
    } else if (!usernameRegExp.hasMatch(username)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<String?> validateUsernameInUse(String username) async {
    final usernameFormatError = validateUsername(username);
    if (usernameFormatError != null) {
      return usernameFormatError;
    }

    bool isAvailable = await _authRepo.checkUsernameAvalability(username);
    if (!isAvailable) {
      return 'This username is already in use';
    }
    return null;
  }
}
