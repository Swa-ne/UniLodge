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
