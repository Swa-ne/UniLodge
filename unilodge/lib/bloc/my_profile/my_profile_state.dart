import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String username;
  final String bio;
  final String email;
  final String phoneNumber;
  final String birthday;

  const ProfileLoaded({
    required this.name,
    required this.username,
    required this.bio,
    required this.email,
    required this.phoneNumber,
    required this.birthday,
  });

  @override
  List<Object?> get props => [name, username, bio, email, phoneNumber, birthday];
}

class ProfileSaved extends ProfileState {
  final String message;

  const ProfileSaved(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
