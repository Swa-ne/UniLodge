import 'package:unilodge/data/models/booking.dart';

abstract class BookingRepository {
  Future<Booking> getBookingById(String bookingId);
  Future<void> approveBooking(String bookingId);
  Future<void> rejectBooking(String bookingId);
  Future<void> createBooking(Map<String, dynamic> bookingData); 
  Future<List<Booking>> getPendingBookings();  
  Future<void> bookDorm(String userId, String dormId); // for booking dorm
}
