import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/data/models/booking.dart';
import 'package:unilodge/data/repository/booking_repository.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/booking";

class BookingRepositoryImpl implements BookingRepository {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  // Fetch booking by ID
  @override
  Future<Booking> getBookingById(String bookingId) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    // Debugging headers and request info
    print("Fetching booking by ID: $bookingId");
    print("Access token: $access_token");

    try {
      final response = await http.get(
        Uri.parse('$_apiUrl/$bookingId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': access_token,
          'Cookie': 'refresh_token=$refresh_token',
        },
      );

      // Debugging response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return Booking.fromJson(responseBody['message']);
      } else {
        throw Exception('Failed to load booking: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching booking by ID: $e');
      throw Exception('Error fetching booking by ID: $e');
    }
  }

  @override
Future<List<Booking>> getBookingsForListing(String listingId) async {
  final access_token = await _tokenController.getAccessToken();
  final response = await http.get(
    Uri.parse('$_apiUrl/listings/$listingId/bookings'), // Ensure this URL is correct
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': access_token,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((bookingData) => Booking.fromJson(bookingData)).toList();
  } else {
    throw Exception('Failed to load bookings for listing: Status code ${response.statusCode}');
  }
}

  // Approve booking
  @override
  Future<void> approveBooking(String bookingId) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    print("Approving booking ID: $bookingId");

    try {
      final response = await http.put(
        Uri.parse('$_apiUrl/$bookingId/approve'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': access_token,
          'Cookie': 'refresh_token=$refresh_token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to approve booking: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error approving booking: $e');
      throw Exception('Error approving booking: $e');
    }
  }

  // Reject booking
  @override
  Future<void> rejectBooking(String bookingId) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    print("Rejecting booking ID: $bookingId");

    try {
      final response = await http.put(
        Uri.parse('$_apiUrl/$bookingId/reject'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': access_token,
          'Cookie': 'refresh_token=$refresh_token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to reject booking: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error rejecting booking: $e');
      throw Exception('Error rejecting booking: $e');
    }
  }

  // Create a new booking
  @override
  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    print("Creating a new booking with data: $bookingData");

    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/create-booking'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': access_token,
          'Cookie': 'refresh_token=$refresh_token',
        },
        body: jsonEncode(bookingData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 201) {
        throw Exception(
            'Failed to create booking: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error creating booking: $e');
      throw Exception('Error creating booking: $e');
    }
  }

  // Fetch pending bookings
  @override
  Future<List<Booking>> getPendingBookings() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    print("Fetching pending bookings");

    try {
      final response = await http.get(
        Uri.parse('$_apiUrl/pending'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': access_token,
          'Cookie': 'refresh_token=$refresh_token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> bookingsJson = json.decode(response.body)['message'];
        return bookingsJson.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load pending bookings: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error fetching pending bookings: $e');
      throw Exception('Error fetching pending bookings: $e');
    }
  }

  // Fetch all bookings
  @override
  Future<List<Booking>> getAllBookings() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    print("Fetching all bookings");

    try {
      final response = await http.get(
        Uri.parse('$_apiUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': access_token,
          'Cookie': 'refresh_token=$refresh_token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> bookingsJson = json.decode(response.body)['message'];
        return bookingsJson.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load all bookings: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error fetching all bookings: $e');
      throw Exception('Error fetching all bookings: $e');
    }
  }
}
