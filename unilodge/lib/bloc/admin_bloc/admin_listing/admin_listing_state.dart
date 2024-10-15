import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/listing.dart';

abstract class AdminListingState extends Equatable {
  const AdminListingState();

  @override
  List<Object> get props => [];
}


class ListingInitial extends AdminListingState {}

class ListingLoading extends AdminListingState {}

class ListingLoaded extends AdminListingState {
  final List<Listing> listings;
  const ListingLoaded(this.listings);
}

class ListingError extends AdminListingState {
  final String message;
  const ListingError(this.message);
}

class ApproveListingSuccess extends AdminListingState {
  final DateTime date;

  const ApproveListingSuccess(this.date);

  @override
  List<Object> get props => [date];
}

class ApproveListingError extends AdminListingState {
  final String error;

  const ApproveListingError(this.error);

  @override
  List<Object> get props => [error];
}

class DeclineListingSuccess extends AdminListingState {
  final DateTime date;

  const DeclineListingSuccess(this.date);

  @override
  List<Object> get props => [date];
}

class DeclineRejectError extends AdminListingState {
  final String error;

  const DeclineRejectError(this.error);

  @override
  List<Object> get props => [error];
}
