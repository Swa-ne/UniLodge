import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/booking.dart';

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

class BookingApproved extends BookingState {}

class BookingRejected extends BookingState {}

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