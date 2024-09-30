import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpUserModel {
  final String first_name;
  final String? middle_name;
  final String last_name;
  final String username;
  final String email;
  final String password_hash;
  final String confirmation_password;
  final PhoneNumber personal_number;
  final String birthday;

  SignUpUserModel({
    required this.first_name,
    this.middle_name,
    required this.last_name,
    required this.username,
    required this.email,
    required this.password_hash,
    required this.confirmation_password,
    required this.personal_number,
    required this.birthday,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'middle_name': middle_name,
      'last_name': last_name,
      'username': username,
      'personal_email': email,
      'password_hash': password_hash,
      'confirmation_password': confirmation_password,
      'personal_number': personal_number.phoneNumber,
      'birthday': birthday,
    };
  }
}
