import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class FetchAllBookingsEvent extends BookingEvent {}

class FetchBookingByIdEvent extends BookingEvent {
  final String bookingId;

  const FetchBookingByIdEvent(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class ApproveBookingEvent extends BookingEvent {
  final String bookingId;

  const ApproveBookingEvent(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class RejectBookingEvent extends BookingEvent {
  final String bookingId;

  const RejectBookingEvent(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class PayBookingEvent extends BookingEvent {
  final String bookingId;

  const PayBookingEvent(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class CreateBookingEvent extends BookingEvent {
  final Map<String, dynamic> bookingData;

  const CreateBookingEvent(this.bookingData);

  @override
  List<Object> get props => [bookingData];
}

// For booking a dorm
class BookDormEvent extends BookingEvent {
  final String userId;
  final String dormId;

  const BookDormEvent(this.userId, this.dormId);

  @override
  List<Object> get props => [userId, dormId];
}

class FetchBookingsForListingEvent extends BookingEvent {
  final String listingId;

  FetchBookingsForListingEvent(this.listingId);
  @override
  List<Object> get props => [listingId];
}

class CheckIfBookedEvent extends BookingEvent {
  final String? listingId;

  const CheckIfBookedEvent(this.listingId);
  @override
  List<Object> get props => [];
}

class CancelBookingEvent extends BookingEvent {
  final String bookingId;
  const CancelBookingEvent(this.bookingId);
}


class GetBookingsOfUserEvent extends BookingEvent {}
