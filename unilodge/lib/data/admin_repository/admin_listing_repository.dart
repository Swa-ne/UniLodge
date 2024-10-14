import 'package:unilodge/data/models/admin_listing.dart';

abstract class AdminListingRepository {
  Future<List<AdminListing>> adminFetchListings();
  // Future<bool> createListing(List<File> imageFiles, AdminListing dorm);
  // Future<bool> AdminDeleteListing(String id); 
  // Future<bool> toggleListing(String id); 
  // Future<bool> updateListing(String id, List<File>? imageFiles, AdminListing listing); 
  Future<bool> acceptListing(String id); 
  Future<bool> rejectListing(String id);
}
