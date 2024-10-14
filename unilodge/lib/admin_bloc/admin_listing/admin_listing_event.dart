import 'package:equatable/equatable.dart';

abstract class AdminListingEvent extends Equatable {
  const AdminListingEvent();

  @override
  List<Object> get props => [];
}

class FetchListings extends AdminListingEvent {}

class FetchAllDormsByStatus extends AdminListingEvent {
  final String listingStatus;

  FetchAllDormsByStatus(this.listingStatus);
  @override
  List<Object> get props => [listingStatus];
}

class DeleteListing extends AdminListingEvent {
  final String id;

  const DeleteListing(this.id);

  @override
  List<Object> get props => [id];
}

class SelectCardEvent extends AdminListingEvent {
  final String cardName;

  const SelectCardEvent(this.cardName);

  @override
  List<Object> get props => [cardName];
}

// accepting and rejecting a listing
class AcceptListing extends AdminListingEvent {
  final String id;

  const AcceptListing(this.id);

  @override
  List<Object> get props => [id];
}

class RejectListing extends AdminListingEvent {
  final String id;

  const RejectListing(this.id);

  @override
  List<Object> get props => [id];
}
