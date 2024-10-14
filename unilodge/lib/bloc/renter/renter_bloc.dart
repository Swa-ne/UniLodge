import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/data/repository/renter_repository.dart';

part 'renter_event.dart';
part 'renter_state.dart';

class RenterBloc extends Bloc<RenterEvent, RenterState> {
  final RenterRepository renterRepository;

  RenterBloc({required this.renterRepository}) : super(RenterInitial()) {
    // on<FetchAllDorms>((event, emit) async {
    //   try {
    //     emit(DormsLoading());

    //     final listings = await renterRepository.fetchAllDorms();

    //     emit(DormsLoaded(
    //         listings));
    //   } catch (e) {
    //     emit(const DormsError("Internet Connection Error"));
    //   }
    // });

    on<FetchAllDorms>((event, emit) async {
      try {
        emit(DormsLoading());

        final listings = await renterRepository.fetchAllDorms();
        final savedDorms = await renterRepository.fetchSavedDorms();

        emit(AllDormsLoaded(listings, savedDorms));
      } catch (e) {
        emit(const DormsError("Internet Connection Error"));
      }
    });

    on<FetchAllDormsByType>((event, emit) async {
      try {
        emit(DormsLoading());
        final listings = await renterRepository.fetchAllDorms();

        print('Filtering listings by type: ${event.listingType}');
        final filteredListings = listings.where((listing) {
          final listingType =
              listing.selectedPropertyType?.trim().toLowerCase();
          print('Listing Type: $listingType');
          return listingType == event.listingType.trim().toLowerCase();
        }).toList();

        print("this is from the bloc");
        print(filteredListings);

        emit(DormsLoaded(filteredListings));
      } catch (e) {
        emit(const DormsError("Internet Connection Error"));
      }
    });

    on<PostReview>((event, emit) async {
      emit(ReviewPosting());
      try {
        await renterRepository.postReview(
            event.userId, event.dormId, event.stars, event.comment);
        emit(const ReviewPosted("Review posted successfully!"));
      } catch (e) {
        emit(const ReviewError("Internet Connection Error"));
      }
    });

    on<FetchSavedDorms>((event, emit) async {
      try {
        emit(DormsLoading());
        final savedDorms= await renterRepository.fetchSavedDorms();
        emit(DormsLoaded(savedDorms));
      } catch (e) {
        emit(DormsError(e.toString()));
      }
    });

    on<SaveDorm>((event, emit) async {
      // emit(DormSaving());
      try {
        emit(DormSaving());
        await renterRepository.saveDorm(event.dormId);
        emit(const DormSaved("Dorm saved successfully!"));
        add(FetchSavedDorms());
      } catch (e) {
        emit(DormSaveError(e.toString()));
      }
    });

    on<DeleteSavedDorm>((event, emit) async {
      // emit(DormSaving());
      try {
        emit(DormSaving());
        await renterRepository.deleteSavedDorm(event.dormId);
        emit(const DormSaved("Dorm removed from saved list!"));
        add(FetchSavedDorms());
      } catch (e) {
        emit(DormSaveError(e.toString()));
      }
    });
  }
}
