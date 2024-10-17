import 'package:unilodge/data/models/listing.dart';

abstract class AdminListingRepository {
  Future<List<Listing>> adminFetchListings();
  Future<bool> approveListing(String id); 
  Future<bool> declineListing(String id);
}
