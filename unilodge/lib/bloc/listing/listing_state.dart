import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/listing.dart';

abstract class ListingState extends Equatable {
  const ListingState();

  @override
  List<Object> get props => [];
}

class ListingLoading extends ListingState {}

class ListingLoaded extends ListingState {
  final List<Listing> listing;

  const ListingLoaded(this.listing);

  @override
  List<Object> get props => [listing];
}

class ListingError extends ListingState {
  final String message;

  const ListingError(this.message);

  @override
  List<Object> get props => [message];
}

class ListingCreated extends ListingState {}

class ListingCreationError extends ListingState {
  final String error;

  const ListingCreationError(this.error);

  @override
  List<Object> get props => [error];
}

class CardSelectedState extends ListingState {
  final Listing listing;
  final String cardName;

  const CardSelectedState(this.listing, this.cardName);
  String get selectedCard => cardName;

  @override
  List<Object> get props => [listing, cardName];
}
