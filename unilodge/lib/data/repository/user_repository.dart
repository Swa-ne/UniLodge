import 'package:unilodge/data/models/user_profile.dart';

abstract class UserRepository {
  Future<UserProfileModel> fetchCurrentUser();
  Future<void> updateUserProfile(UserProfileModel user);
}
