import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class SaveProfile extends ProfileEvent {
  final String firstName;
  final String middleName;
  final String lastName;
  final String username;
  final String fullName;
  final String profilePictureUrl;
  final String personalEmail;
  final DateTime birthday;

  const SaveProfile({
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
