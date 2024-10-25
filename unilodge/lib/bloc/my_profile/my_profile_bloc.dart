import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/data/models/user_profile.dart';
import 'package:unilodge/data/repository/user_repository.dart';
import 'my_profile_event.dart';
import 'my_profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(ProfileLoading()) {
    // Load profile
    on<LoadProfile>((event, emit) async {
      try {
        final userData = await userRepository.fetchCurrentUser();
        emit(ProfileLoaded(
          firstName: userData.firstName,
          middleName: userData.middleName,
          lastName: userData.lastName,
          username: userData.username,
          fullName: userData.fullName,
          profilePictureUrl: userData.profilePictureUrl,
          personalEmail: userData.personalEmail,
          birthday: userData.birthday,
        ));
      } catch (e) {
        emit(const ProfileError('Failed to load profile'));
      }
    });

    on<SaveProfile>((event, emit) async {
      emit(ProfileSaving());

      try {
        final updatedUser = UserProfileModel(
          firstName: event.firstName,
          middleName: event.middleName,
          lastName: event.lastName,
          username: event.username,
          fullName: event.fullName,
          profilePictureUrl: event.profilePictureUrl,
          personalEmail: event.personalEmail,
          birthday: event.birthday,
        );

        await userRepository.updateUserProfile(updatedUser);
        add(LoadProfile());
      } catch (e) {
        emit(const ProfileError('Failed to save profile'));
      }
    });
  }
}
