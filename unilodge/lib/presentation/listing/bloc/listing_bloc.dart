import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/data/models/listing.dart';
import 'listing_event.dart';
import 'listing_state.dart';
import 'package:unilodge/data/sources/listing/listing_repo.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  final ListingRepo _listingRepo;

  ListingBloc(this._listingRepo) : super(ListingInitial()) {

    // Handle card selection event
    on<SelectCardEvent>((event, emit) {
      if (state is ListingInitial) {
        final listing = Listing(selectedPropertyType: event.cardName);
        emit(CardSelectedState(listing, event.cardName));
      } else if (state is CardSelectedState) {
        final listing = (state as CardSelectedState).listing;
        final updatedListing = listing.copyWith(selectedPropertyType: event.cardName);
        emit(CardSelectedState(updatedListing, event.cardName));
      }
    });

    // Handle image upload event
    on<UploadImagesEvent>((event, emit) async {
      emit(ImageUploadInProgress()); // Emit loading state

      try {
     
        await _listingRepo.uploadimageurlWithData(event.images, event.listing);

        if (state is CardSelectedState) {
          final currentListing = (state as CardSelectedState).listing;

         
          final updatedListing = currentListing.copyWith(
            imageUrl: event.images.map((e) => e.path).join(','), 
          );

          
          emit(CardSelectedState(updatedListing, updatedListing.selectedPropertyType ?? ''));
        }

        emit(ImagesUploadedState(event.images.map((e) => e.path).toList()));

      } catch (e) {
        emit(ImageUploadFailure(e.toString()));
      }
    });
  }
}
