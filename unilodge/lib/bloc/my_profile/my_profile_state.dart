import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String firstName;
  final String middleName;
  final String lastName;
  final String username;
  final String fullName;
  final String profilePictureUrl;
  final String personalEmail;
  final DateTime birthday;

  const ProfileLoaded({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.username,
    required this.fullName,
    required this.profilePictureUrl,
    required this.personalEmail,
    required this.birthday,
  });

  @override
  List<Object?> get props => [
        firstName,
        middleName,
        lastName,
        username,
        fullName,
        profilePictureUrl,
        personalEmail,
        birthday,
      ];
}
class ProfileSaving extends ProfileState {}

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
