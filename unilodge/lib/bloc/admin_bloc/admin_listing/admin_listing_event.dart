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

class ApproveListing extends AdminListingEvent {
  final String id;

  const ApproveListing(this.id);

  @override
  List<Object> get props => [id];
}

class DeclineListing extends AdminListingEvent {
  final String id;

  const DeclineListing(this.id);

  @override
  List<Object> get props => [id];
}
