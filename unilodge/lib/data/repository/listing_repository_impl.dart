import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/data/repository/listing_repository.dart';

class ListingRepositoryImpl implements ListingRepository {
  static const String baseUrl = '';

  @override
  Future<List<Listing>> fetchListings() async {
    final response = await http.get(Uri.parse('$baseUrl/my-dorms'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['listings'];
      return data.map((json) => Listing.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load listings');
    }
  }

  @override
  Future<void> createListing(Listing listing) async {
    final response = await http.post(
      Uri.parse('$baseUrl/post-dorm'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(listing.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create listing');
    }
  }

  @override
  Future<void> updateListing(String id, Listing listing) async {
    final response = await http.put(
      Uri.parse('$baseUrl/edit-dorm/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(listing.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update listing');
    }
  }

  @override
  Future<void> deleteListing(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/listing/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete listing');
    }
  }

  @override
  Future<void> toggleListing(String id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/toggle-visibility/$id'),
    );

    if (response.statusCode != 200) {
      final errorResponse = jsonDecode(response.body);
      throw Exception('Failed to update listing: ${errorResponse['error']}');
    }
  }
}
