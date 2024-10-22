import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/data/models/user_profile.dart';

abstract class AdminListingRepository {
  Future<List<Listing>> adminFetchListings();
  Future<List<Listing>> adminFetchUserListings(String user_id);
  Future<List<UserProfileModel>> adminFetchUsers();
  Future<bool> approveListing(String id);
  Future<bool> declineListing(String id);
}
