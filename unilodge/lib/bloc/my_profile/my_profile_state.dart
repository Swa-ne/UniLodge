import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  // final String id;
  final String fullName;
  final String username;
  final String profilePictureUrl;
  final String personalEmail;
  final DateTime birthday;

  const ProfileLoaded({
    // required this.id,
    required this.fullName,
    required this.username,
    required this.profilePictureUrl,
    required this.personalEmail,
    required this.birthday,
  });

  @override
  List<Object?> get props => [
        // id,
        fullName,
        username,
        profilePictureUrl,
        personalEmail,
        birthday,
      ];
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
