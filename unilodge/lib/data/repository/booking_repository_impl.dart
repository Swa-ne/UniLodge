import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unilodge/data/models/booking.dart';
import 'package:unilodge/data/models/booking_history.dart';
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
        Uri.parse('$_apiUrl/get-booking/$bookingId'),
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
Future<List<BookingHistory>> getBookingsOfUser() async {
  final access_token = await _tokenController.getAccessToken();
  final refresh_token = await _tokenController.getRefreshToken();

  try {
    final response = await http.get(
      Uri.parse('$_apiUrl/booking-history'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );

    if (response.statusCode == 200) {
      print('Response statussssessssss: ${response.statusCode}');
      print('Response body: ${response.body}');
      List<dynamic> jsonResponse = jsonDecode(response.body)["message"];

    
      List<BookingHistory> bookings = [];
      try {
        bookings = jsonResponse.map((json) {
          try {
            if (json['listing_id'] != null) {
              return BookingHistory.fromJson(json);
            } else {
              print('Skipping entry due to missing listing information: $json');
              return null;
            }
          } catch (e) {
            print('Error parsing booking entry: $e');
            return null;
          }
        }).whereType<BookingHistory>().toList(); 
      } catch (e) {
        print('Error parsing bookings: $e');
      }
      return bookings;
    } else {
      throw Exception('Failed to load bookings: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching bookings by user: $e');
    throw Exception('Failed to fetch bookings');
  }
}





  @override
  Future<List<Booking>> getBookingsForListing(String listingId) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    print("url is $_apiUrl/listings/$listingId/bookings");
    final response = await http.get(
      Uri.parse(
          '$_apiUrl/listings/bookings/$listingId'), // Ensure this URL is correct
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    print("${response.statusCode} and the body is ${response.body}");
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)["message"];
      print("here is the data $data");
      return data.map((bookingData) => Booking.fromJson(bookingData)).toList();
    } else {
      throw Exception(
          'Failed to load bookings for listing: Status code ${response.statusCode}');
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
        Uri.parse('$_apiUrl/approve-booking/$bookingId'),
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
        Uri.parse('$_apiUrl/reject-booking/$bookingId'),
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

    @override
  Future<void> payBooking(String bookingId) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    print("Pay booking ID: $bookingId");

    try {
      final response = await http.put(
        Uri.parse('$_apiUrl/pay-booking/$bookingId'),
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
        final List<dynamic> bookingsJson =
            json.decode(response.body)['message'];
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
        final List<dynamic> bookingsJson =
            json.decode(response.body)['message'];
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

  @override
  Future<bool> checkIfBooked(String dormId) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    print("Fetching all bookings $dormId");

    try {
      final response = await http.get(
        Uri.parse('$_apiUrl/check-if-booked/$dormId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': access_token,
          'Cookie': 'refresh_token=$refresh_token',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        return json.decode(response.body)['message'] == "Booked";
      } else {
        throw Exception('Internet Connection Error');
      }
    } catch (e) {
      print('Error fetching all bookings: $e');
      throw Exception('Error fetching all bookings: $e');
    }
  }
}
