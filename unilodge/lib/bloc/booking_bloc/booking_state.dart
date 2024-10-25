import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/booking.dart';
import 'package:unilodge/data/models/booking_history.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final Booking booking;

  const BookingLoaded(this.booking);

  @override
  List<Object> get props => [booking];
}

class AllBookingsLoaded extends BookingState {
  final List<Booking> bookings;

  const AllBookingsLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class AllBookingsEmptyLoaded extends BookingState {}

class BookingsOfUserLoaded extends BookingState {
  final List<BookingHistory> listings;

  const BookingsOfUserLoaded(this.listings);

  @override
  List<Object> get props => [listings];
}

class BookingsOfUserEmptyLoaded extends BookingState {}

class BookingsOfUserError extends BookingState {
  final String errorMessage;

  const BookingsOfUserError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class BookingApproved extends BookingState {
  final String bookingId;

  const BookingApproved(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class BookingRejected extends BookingState {
  final String bookingId;

  const BookingRejected(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class BookingPaid extends BookingState {
  final String bookingId;

  const BookingPaid(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class BookingCreated extends BookingState {}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object> get props => [message];
}

// For successful dorm booking
class DormBookedSuccess extends BookingState {
  final String successMessage;

  const DormBookedSuccess(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

// For failed dorm booking
class DormBookedError extends BookingState {
  final String errorMessage;

  const DormBookedError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class CheckIfBookedSuccess extends BookingState {
  final bool isBooked;

  const CheckIfBookedSuccess(this.isBooked);

  @override
  List<Object> get props => [isBooked];
}

class CheckIfBookedError extends BookingState {
  final String errorMessage;

  const CheckIfBookedError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
