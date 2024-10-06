import 'package:unilodge/data/models/renter.dart';

abstract class RenterRepository {
  Future<List<SavedDorm>> fetchSavedDorms(String userId);
  Future<void> postReview(
      String userId, String dormId, int stars, String comment);
  Future<void> saveDorm(String userId, String dormId);
  Future<void> deleteSavedDorm(String userId, String dormId);
}