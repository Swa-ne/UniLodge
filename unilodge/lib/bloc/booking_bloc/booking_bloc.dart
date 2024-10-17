import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/data/repository/booking_repository.dart';
import 'package:unilodge/bloc/booking_bloc/booking_event.dart';
import 'package:unilodge/bloc/booking_bloc/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc(this.bookingRepository) : super(BookingInitial()) {
    
    // Fetch booking by ID
    on<FetchBookingByIdEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        final booking = await bookingRepository.getBookingById(event.bookingId);
        emit(BookingLoaded(booking));
      } catch (e) {
        emit(BookingError('Failed to load booking: $e'));
      }
    });

    // Approve booking
    on<ApproveBookingEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        await bookingRepository.approveBooking(event.bookingId);
        emit(BookingApproved());  // Emit BookingApproved state after successful approval
      } catch (e) {
        emit(BookingError('Failed to approve booking: $e'));
      }
    });

    // Reject booking
    on<RejectBookingEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        await bookingRepository.rejectBooking(event.bookingId);
        emit(BookingRejected());  // Emit BookingRejected state after successful rejection
      } catch (e) {
        emit(BookingError('Failed to reject booking: $e'));
      }
    });

    // Create new booking
    on<CreateBookingEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        await bookingRepository.createBooking(event.bookingData); // Call repository to create a new booking
        emit(BookingCreated());  // Emit BookingCreated state after booking is created successfully
      } catch (e) {
        emit(BookingError('Failed to create booking: $e'));
      }
    });
  }
}
