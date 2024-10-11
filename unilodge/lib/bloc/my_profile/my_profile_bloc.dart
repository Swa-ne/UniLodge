import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/data/models/user_profile.dart';
import 'package:unilodge/data/repository/user_repository.dart';
import 'my_profile_event.dart';
import 'my_profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(ProfileLoading()) {
    on<LoadProfile>((event, emit) async {
      try {
        final userData = await userRepository.fetchCurrentUser();
        emit(ProfileLoaded(
          // id: userData.id,
          fullName: userData.fullName,
          username: userData.username,
          profilePictureUrl: userData.profilePictureUrl, 
          personalEmail: userData.personalEmail,         
          personalNumber: userData.personalNumber,       
          birthday: userData.birthday,                  
        ));
      } catch (e) {
        emit(const ProfileError('Failed to load profile'));
      }
    });

    on<SaveProfile>((event, emit) async {
      try {
        final updatedUser = UserProfileModel(
          // id: event.id, 
          fullName: event.fullName,
          username: event.username,
          profilePictureUrl: event.profilePictureUrl, 
          personalEmail: event.personalEmail,        
          personalNumber: event.personalNumber,       
          birthday: event.birthday,                  
        );

        await userRepository.updateUserProfile(updatedUser);
        emit(ProfileLoaded(
          // id: updatedUser.id,
          fullName: updatedUser.fullName,
          username: updatedUser.username,
          profilePictureUrl: updatedUser.profilePictureUrl, 
          personalEmail: updatedUser.personalEmail,        
          personalNumber: updatedUser.personalNumber,       
          birthday: updatedUser.birthday,                 
        ));
      } catch (e) {
        emit(const ProfileError('Failed to save profile'));
      }
    });
  }
}
