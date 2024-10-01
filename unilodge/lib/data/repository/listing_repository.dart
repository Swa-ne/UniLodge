import 'package:unilodge/data/models/listing.dart';

abstract class ListingRepository {
  Future<List<Listing>> fetchListings();
  Future<void> createListing(Listing listing);
  Future<void> deleteListing(String id);
  Future<void> updateListing(String id, Listing listing);
}
