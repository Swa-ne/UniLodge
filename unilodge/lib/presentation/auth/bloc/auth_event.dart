import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/signUpUser.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final SignUpUserModel user;

  const SignUpEvent(this.user);

  @override
  List<Object> get props => [user];
}

class VerifyEmailEvent extends AuthEvent {
  final String token;
  final String code;

  const VerifyEmailEvent(this.token, this.code);

  @override
  List<Object> get props => [token, code];
}

class ResendEmailCodeEvent extends AuthEvent {
  final String token;

  const ResendEmailCodeEvent(this.token);

  @override
  List<Object> get props => [token];
}
