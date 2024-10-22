import 'package:unilodge/data/models/booking.dart';
import 'package:unilodge/data/models/booking_history.dart';

abstract class BookingRepository {
  Future<Booking> getBookingById(String bookingId);
  Future<void> approveBooking(String bookingId);
  Future<void> rejectBooking(String bookingId);
  Future<void> payBooking(String bookingId);
  Future<void> createBooking(Map<String, dynamic> bookingData);
  Future<List<Booking>> getPendingBookings();
  Future<void> bookDorm(String userId, String dormId); // for booking dorm
  Future<List<Booking>> getAllBookings();
  Future<List<Booking>> getBookingsForListing(String listingId);
  Future<List<BookingHistory>> getBookingsOfUser();
  Future<bool> checkIfBooked(String listingId);
}
