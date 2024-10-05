import 'package:flutter_bloc/flutter_bloc.dart';
import 'listing_event.dart';
import 'listing_state.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  ListingBloc() : super(ListingInitial()) {
    on<SelectCardEvent>((event, emit) {
      emit(CardSelectedState(event.cardName));
    });
  }
}
