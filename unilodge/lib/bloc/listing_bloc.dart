import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unilodge/bloc/listing_event.dart';
import 'package:unilodge/bloc/listing_state.dart';
import 'package:unilodge/data/repository/listing_repository.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  final ListingRepository _listingRepository;

  ListingBloc(this._listingRepository) : super(ListingLoading()) {
    on<FetchListings>((event, emit) async {
      try {
        emit(ListingLoading());
        final listings = await _listingRepository.fetchListings();
        emit(ListingLoaded(listings));
      } catch (e) {
        emit(ListingError(e.toString()));
      }
    });

    on<CreateListing>((event, emit) async {
      try {
        await _listingRepository.createListing(event.listing);
        add(FetchListings()); 
      } catch (e) {
        emit(ListingError(e.toString()));
      }
    });

    on<UpdateListing>((event, emit) async {
      try {
        await _listingRepository.updateListing(event.id, event.listing);
        add(FetchListings());
      } catch (e) {
        emit(ListingError(e.toString()));
      }
    });

    on<DeleteListing>((event, emit) async {
      try {
        await _listingRepository.deleteListing(event.id);
        add(FetchListings()); 
      } catch (e) {
        emit(ListingError(e.toString()));
      }
    });
    
  }
}
