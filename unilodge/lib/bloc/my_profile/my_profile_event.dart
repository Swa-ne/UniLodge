import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class SaveProfile extends ProfileEvent {
  // final String id; 
  final String fullName;
  final String username;
  final String profilePictureUrl;
  final String personalEmail;    
  final String personalNumber;     
  final DateTime birthday;         

  const SaveProfile({
    // required this.id,
    required this.fullName,
    required this.username,
    required this.profilePictureUrl, 
    required this.personalEmail,      
    required this.personalNumber,     
    required this.birthday,          
  });

  @override
  List<Object?> get props => [
    // id,
    fullName,
    username,
    profilePictureUrl, 
    personalEmail,     
    personalNumber,     
    birthday,          
  ];
}
