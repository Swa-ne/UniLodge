import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class SaveProfile extends ProfileEvent {
  final String username;
  final String bio;

  const SaveProfile({
    required this.username,
    required this.bio,
  });

  @override
  List<Object?> get props => [username, bio];
}
