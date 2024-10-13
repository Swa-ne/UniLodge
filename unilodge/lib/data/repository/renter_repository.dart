import 'package:unilodge/data/models/listing.dart';

abstract class RenterRepository {
  Future<List<Listing>> fetchAllDorms();
  Future<List<Listing>> fetchSavedDorms();
  Future<void> postReview(
      String userId, String dormId, int stars, String comment);
  Future<bool> saveDorm(String dormId);
  Future<bool> deleteSavedDorm(String dormId);
  Future<bool> isDormSaved(String dormId);
}
