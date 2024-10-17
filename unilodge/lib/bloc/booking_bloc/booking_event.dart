import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

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

class CreateBookingEvent extends BookingEvent {
  final Map<String, dynamic> bookingData;

  const CreateBookingEvent(this.bookingData);

  @override
  List<Object> get props => [bookingData];
}
