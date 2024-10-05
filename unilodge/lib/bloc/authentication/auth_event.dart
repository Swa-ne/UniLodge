import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/login_user.dart';
import 'package:unilodge/data/models/sign_up_user.dart';

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

class LoginEvent extends AuthEvent {
  final LoginUserModel user;

  const LoginEvent(this.user);

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

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent(this.email);

  @override
  List<Object> get props => [email];
}

class PostResetPasswordEvent extends AuthEvent {
  final String token;
  final String password;
  final String confirmation_password;

  const PostResetPasswordEvent(
      this.token, this.password, this.confirmation_password);

  @override
  List<Object> get props => [token, password, confirmation_password];
}

class AuthenticateTokenEvent extends AuthEvent {}
