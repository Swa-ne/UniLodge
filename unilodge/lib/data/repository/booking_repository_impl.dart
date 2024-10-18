import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/data/models/booking.dart';
import 'package:unilodge/data/repository/booking_repository.dart';
import 'package:unilodge/data/sources/auth/token_controller.dart';

class BookingRepositoryImpl implements BookingRepository {
  final String _apiUrl = "${dotenv.env['API_URL']}/booking";
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<Booking> getBookingById(String bookingId) async {
    final response = await http.get(
      Uri.parse('$_apiUrl/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Booking.fromJson(json.decode(response.body)['message']);
    } else {
      throw Exception('Failed to load booking');
    }
  }

  @override
  Future<void> approveBooking(String bookingId) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/$bookingId/approve'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve booking');
    }
  }

  @override
  Future<void> rejectBooking(String bookingId) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/$bookingId/reject'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reject booking');
    }
  }

  // Implement createBooking method to send booking data to the backend
  @override
  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    final response = await http.post(
      Uri.parse('$_apiUrl/create-booking'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
      body: jsonEncode(bookingData), // Send bookingData to backend
    );

    if (response.statusCode != 201) {
      // Assuming 201 status code for successful creation
      throw Exception('Failed to create booking');
    }
  }

  @override
  Future<List<Booking>> getPendingBookings() async {
    final response = await http.get(
      Uri.parse('$_apiUrl/pending'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> bookingsJson = json.decode(response.body)['message'];
      return bookingsJson.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pending bookings');
    }
  }

  @override
  Future<void> bookDorm(String userId, String dormId) async {
    // Prepare the booking data
    final bookingData = {
      'userId': userId,
      'dormId': dormId,
      // pa-add na lang nung iba
    };

    // Call createBooking to send the booking data to the backend
    await createBooking(bookingData);
  }
}
