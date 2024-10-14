import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_event.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_state.dart';
import 'package:unilodge/data/repository/admin_repository/admin_listing_repository.dart';
import 'package:unilodge/data/models/listing.dart';

class AdminBloc extends Bloc<AdminListingEvent, AdminListingState> {
  final AdminListingRepository _listingRepository;

  AdminBloc(this._listingRepository) : super(ListingLoading()) {
    on<FetchListings>((event, emit) async {
      try {
        emit(FetchingLoading());
        final listings = await _listingRepository.adminFetchListings();
        emit(ListingLoaded(listings));
      } catch (e) {
        emit(const ListingError("Internet Connection Error"));
      }
    });

    on<FetchAllDormsByStatus>((event, emit) async {
      try {
        emit(FetchingLoading());
        final listings = await _listingRepository.adminFetchListings();

        print('Filtering listings by type: ${event.listingStatus}');
        final filteredListings = listings.where((listing) {
          final listingStatus = listing.status?.trim().toLowerCase();
          print('Listing Type: $listingStatus');
          return listingStatus == event.listingStatus.trim().toLowerCase();
        }).toList();

        print("this is from the bloc");
        print(filteredListings);

        emit(ListingLoaded(filteredListings));
      } catch (e) {
        emit(const ListingError("Internet Connection Error"));
      }
    });

    on<AcceptListing>((event, emit) async {
      try {
        final isSuccess = await _listingRepository.acceptListing(event.id);
        if (isSuccess) {
          emit(AcceptListingSuccess(DateTime.now()));
        } else {
          emit(const AcceptRejectError("Failed to accept listing"));
        }
      } catch (e) {
        emit(const AcceptRejectError("Internet Connection Error"));
      }
    });

    on<RejectListing>((event, emit) async {
      try {
        final isSuccess = await _listingRepository.rejectListing(event.id);
        if (isSuccess) {
          emit(RejectListingSuccess(DateTime.now()));
        } else {
          emit(const AcceptRejectError("Failed to reject listing"));
        }
      } catch (e) {
        emit(const AcceptRejectError("Internet Connection Error"));
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
