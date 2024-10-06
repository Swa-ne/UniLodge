import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/listing.dart';

abstract class ListingEvent extends Equatable {
  const ListingEvent();

  @override
  List<Object> get props => [];
}

class FetchListings extends ListingEvent {}

class CreateListing extends ListingEvent {
  final Listing listing;

  const CreateListing(this.listing);

  @override
  List<Object> get props => [listing];
}

class DeleteListing extends ListingEvent {
  final String id;

  const DeleteListing(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateListing extends ListingEvent {
  final String id;
  final Listing listing;

  const UpdateListing(this.id, this.listing);

  @override
  List<Object> get props => [id, listing];
}

class ToggleListing extends ListingEvent {
  final String id;

  const ToggleListing(this.id);

  @override
  List<Object> get props => [id];
}
