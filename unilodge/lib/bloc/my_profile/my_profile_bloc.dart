import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/data/dummy_data/dummy_data_profile.dart';
import 'my_profile_event.dart';
import 'my_profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfile>((event, emit) async {
      try {
        // using dummy data to test
        await Future.delayed(const Duration(seconds: 1));
        emit(const ProfileLoaded(
          name: DummyProfileData.name,
          username: DummyProfileData.username,
          bio: DummyProfileData.bio,
          email: DummyProfileData.email,
          phoneNumber: DummyProfileData.phoneNumber,
          birthday: DummyProfileData.birthday,
        ));
      } catch (e) {
        emit(const ProfileError('Failed to load profile'));
      }
    });

    on<SaveProfile>((event, emit) async {
      try {
        // test test w delay
        await Future.delayed(const Duration(seconds: 1));
        emit(ProfileLoaded(
          name: DummyProfileData.name, // default  
          username: event.username,
          bio: event.bio,
          email: DummyProfileData.email,
          phoneNumber: DummyProfileData.phoneNumber,
          birthday: DummyProfileData.birthday,
        ));
      } catch (e) {
        emit(const ProfileError('Failed to save profile'));
      }
    });
  }
}
