import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {}

class SignUpSuccess extends AuthState {
  final String token;

  const SignUpSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class ResendEmailCodeSuccess extends AuthState {
  final bool isSuccess;

  const ResendEmailCodeSuccess(this.isSuccess);

  @override
  List<Object> get props => [isSuccess];
}

class AuthError extends AuthState {
  final String error;

  const AuthError(this.error);

  @override
  List<Object> get props => [error];
}
