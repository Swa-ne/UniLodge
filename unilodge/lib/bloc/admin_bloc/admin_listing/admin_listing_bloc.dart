import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_event.dart';
import 'package:unilodge/bloc/admin_bloc/admin_listing/admin_listing_state.dart';
import 'package:unilodge/data/repository/admin_repository/admin_listing_repository.dart';

class AdminBloc extends Bloc<AdminListingEvent, AdminListingState> {
  final AdminListingRepository _listingRepository;

  AdminBloc(this._listingRepository) : super(ListingLoading()) {
    on<FetchListings>((event, emit) async {
      try {
        emit(ListingLoading());
        final listings = await _listingRepository.adminFetchListings();
        emit(ListingLoaded(listings));
      } catch (e) {
        emit(const ListingError("Internet Connection Error"));
      }
    });
    on<FetchUserListings>((event, emit) async {
      try {
        emit(ListingLoading());
        final listings =
            await _listingRepository.adminFetchUserListings(event.user_id);
        emit(ListingUserLoaded(listings));
      } catch (e) {
        emit(const ListingUserError("Internet Connection Error"));
      }
    });
    on<FetchUsers>((event, emit) async {
      try {
        emit(ListingLoading());
        final user = await _listingRepository.adminFetchUsers();
        emit(UsersLoaded(user));
      } catch (e) {
        emit(const UsersError("Internet Connection Error"));
      }
    });

    on<FetchAllDormsByStatus>((event, emit) async {
      try {
        emit(ListingLoading());
        final listings = await _listingRepository.adminFetchListings();

        print('Filtering listings by type: ${event.listingStatus}');
        final filteredListings = listings.where((listing) {
          final listingStatus = listing.status?.trim().toLowerCase();
          print('Listing Type: $listingStatus');
          return listingStatus == event.listingStatus.trim().toLowerCase();
        }).toList();
        print(filteredListings);

        emit(ListingLoaded(filteredListings));
      } catch (e) {
        emit(ListingError("Internet Connection Error"));
      }
    });

    on<ApproveListing>((event, emit) async {
      try {
        final isSuccess = await _listingRepository.approveListing(event.id);
        if (isSuccess) {
          emit(ApproveListingSuccess(DateTime.now()));
          add(FetchListings());
        } else {
          emit(const DeclineRejectError("Failed to accept listing"));
        }
      } catch (e) {
        emit(const DeclineRejectError("Internet Connection Error"));
      }
    });

    on<DeclineListing>((event, emit) async {
      try {
        final isSuccess = await _listingRepository.declineListing(event.id);
        if (isSuccess) {
          emit(DeclineListingSuccess(DateTime.now()));
          add(FetchListings());
        } else {
          emit(const DeclineRejectError("Failed to reject listing"));
        }
      } catch (e) {
        emit(const DeclineRejectError("Internet Connection Error"));
      }
    });
  }
}
