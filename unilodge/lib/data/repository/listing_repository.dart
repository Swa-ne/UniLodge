import 'dart:io';

import 'package:unilodge/data/models/listing.dart';

abstract class ListingRepository {
  Future<List<Listing>> fetchListings();
  Future<bool> createListing(List<File> imageFiles, Listing dorm);
  Future<bool> deleteListing(String id);
  Future<bool> toggleListing(String id);
  Future<void> updateListing(String id, Listing listing);
}
