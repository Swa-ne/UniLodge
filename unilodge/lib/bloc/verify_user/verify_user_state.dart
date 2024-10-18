import 'package:equatable/equatable.dart';

abstract class VerifyUserState extends Equatable {
  const VerifyUserState();

  @override
  List<Object> get props => [];
}

class VerifyUserLoading extends VerifyUserState {}

class VerifyUserReady extends VerifyUserState {}

class CheckFaceSuccess extends VerifyUserState {}

class CheckFaceError extends VerifyUserState {
  final String error;

  const CheckFaceError(this.error);

  @override
  List<Object> get props => [error];
}

class CheckIdSuccess extends VerifyUserState {}

class CheckIdError extends VerifyUserState {
  final String error;

  const CheckIdError(this.error);

  @override
  List<Object> get props => [error];
}

class VerifyUserSuccess extends VerifyUserState {}

class VerifyUserError extends VerifyUserState {
  final String error;

  const VerifyUserError(this.error);

  @override
  List<Object> get props => [error];
}
