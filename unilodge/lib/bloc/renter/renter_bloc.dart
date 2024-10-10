import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/listing.dart';
import 'package:unilodge/data/repository/renter_repository.dart';

part 'renter_event.dart';
part 'renter_state.dart';

class RenterBloc extends Bloc<RenterEvent, RenterState> {
  final RenterRepository renterRepository;

  RenterBloc({required this.renterRepository}) : super(RenterInitial()) {
    // on<FetchSavedDorms>((event, emit) async {
    //   emit(RenterInitial());
    //   try {
    //     final savedDorms = await renterRepository.fetchSavedDorms(event.userId);
    //     emit(DormsLoaded(savedDorms));
    //   } catch (e) {
    //     emit(DormsError(e.toString()));
    //   }
    // });

    on<FetchAllDorms>((event, emit) async {
      try {
        emit(DormsLoading());
        final listings = await renterRepository.fetchAllDorms();
        emit(DormsLoaded(listings));
      } catch (e) {
        emit(DormsError(e.toString()));
      }
    });

    on<PostReview>((event, emit) async {
      emit(ReviewPosting());
      try {
        await renterRepository.postReview(
            event.userId, event.dormId, event.stars, event.comment);
        emit(const ReviewPosted("Review posted successfully!"));
      } catch (e) {
        emit(ReviewError(e.toString()));
      }
    });

    on<SaveDorm>((event, emit) async {
      emit(DormSaving());
      try {
        await renterRepository.saveDorm(event.userId, event.dormId);
        emit(const DormSaved("Dorm saved successfully!"));
      } catch (e) {
        emit(DormSaveError(e.toString()));
      }
    });

    on<DeleteSavedDorm>((event, emit) async {
      emit(DormSaving());
      try {
        await renterRepository.deleteSavedDorm(event.userId, event.dormId);
        emit(const DormSaved("Dorm removed from saved list!"));
      } catch (e) {
        emit(DormSaveError(e.toString()));
      }
    });
  }
}
