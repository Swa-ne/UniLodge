import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/signUpUser.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUp extends AuthEvent {
  final SignUpUserModel user;

  const SignUp(this.user);

  @override
  List<Object> get props => [user];
}
