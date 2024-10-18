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

    on<FetchBookingsForListingEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        final bookings =
            await bookingRepository.getBookingsForListing(event.listingId);
        if (bookings.isNotEmpty) {
          emit(AllBookingsLoaded(bookings)); // New state for all bookings
        } else {
          emit(AllBookingsEmptyLoaded());
        }
      } catch (e) {
        emit(BookingError('Failed to load bookings for listing: $e'));
      }
    });

    // Fetch all bookings
    on<FetchAllBookingsEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        final bookings = await bookingRepository.getAllBookings();
        if (bookings.isNotEmpty) {
          emit(AllBookingsLoaded(bookings)); // New state for all bookings
        } else {
          emit(AllBookingsEmptyLoaded());
        }
      } catch (e) {
        emit(BookingError('Failed to load bookings: $e'));
      }
    });

    // Approve booking
    on<ApproveBookingEvent>((event, emit) async {
      try {
        await bookingRepository.approveBooking(event.bookingId);
        emit(BookingApproved(event.bookingId)); // Emit updated bookingId state

        // Fetch updated booking after approval
        final booking = await bookingRepository.getBookingById(event.bookingId);
        emit(BookingLoaded(booking)); // Emit updated booking state
      } catch (e) {
        emit(BookingError('Failed to approve booking: $e'));
      }
    });

    // Reject booking
    on<RejectBookingEvent>((event, emit) async {
      try {
        await bookingRepository.rejectBooking(event.bookingId);
        emit(BookingRejected(event.bookingId)); // Emit updated bookingId state

        // Fetch updated booking after rejection
        final booking = await bookingRepository.getBookingById(event.bookingId);
        emit(BookingLoaded(booking)); // Emit updated booking state
      } catch (e) {
        emit(BookingError('Failed to reject booking: $e'));
      }
    });

    // Create new booking
    on<CreateBookingEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        await bookingRepository.createBooking(event.bookingData);
        emit(BookingCreated());
        // Optionally refetch all bookings if needed
      } catch (e) {
        emit(BookingError('Failed to create booking: $e'));
      }
    });

    // For booking a dorm
    on<BookDormEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        await bookingRepository.bookDorm(
            event.userId, event.dormId); // Call the method to book the dorm
        emit(DormBookedSuccess(
            "Dorm booked successfully!")); // Emit success state
      } catch (e) {
        emit(DormBookedError('Failed to book dorm: $e')); // Emit error state
      }
    });
  }
}
