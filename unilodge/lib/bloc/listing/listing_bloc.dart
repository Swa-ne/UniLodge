import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/listing/listing_event.dart';
import 'package:unilodge/bloc/listing/listing_state.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/data/repository/listing_repository.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  final ListingRepository _listingRepository;

  ListingBloc(this._listingRepository) : super(ListingLoading()) {
    on<FetchListings>((event, emit) async {
      try {
        emit(FetchingLoading());
        final listings = await _listingRepository.fetchListings();
        emit(ListingLoaded(listings));
      } catch (e) {
        emit(ListingError(e.toString()));
      }
    });

    on<CreateListing>((event, emit) async {
      try {
        if (await _listingRepository.createListing(
            event.imageFiles, event.dorm)) {
          emit(ListingCreated());
        } else {
          emit(const ListingCreationError("Internet Connection Error"));
        }
      } catch (e) {
        emit(ListingCreationError(e.toString()));
      }
    });

    on<UpdateListing>((event, emit) async {
      try {
        await _listingRepository.updateListing(event.id, event.listing);
        // add(FetchListings());
      } catch (e) {
        emit(ListingError(e.toString()));
      }
    });

    on<ToggleListing>((event, emit) async {
      try {
        final isSuccess = await _listingRepository.toggleListing(event.id);
        if (isSuccess) {
          emit(SuccessToggle(DateTime.now()));
        } else {
          emit(const ToggleError("Internet Connection Error"));
        }
      } catch (e) {
        emit(ToggleError(e.toString()));
      }
    });

    on<DeleteListing>((event, emit) async {
      try {
        final isSuccess = await _listingRepository.deleteListing(event.id);
        if (isSuccess) {
          emit(SuccessDeleted());
        } else {
          emit(const DeletionError("Internet Connection Error"));
        }
      } catch (e) {
        emit(DeletionError(e.toString()));
      }
    });
    on<SelectCardEvent>((event, emit) {
      if (state is CardSelectedState) {
        final listing = (state as CardSelectedState).listing;
        final updatedListing =
            listing.copyWith(selectedPropertyType: event.cardName);
        emit(CardSelectedState(updatedListing, event.cardName));
      } else {
        final listing = Listing(selectedPropertyType: event.cardName);
        emit(CardSelectedState(listing, event.cardName));
      }
    });
  }
}
