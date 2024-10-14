import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/listing.dart';

abstract class AdminListingState extends Equatable {
  const AdminListingState();

  @override
  List<Object> get props => [];
}

class ListingLoading extends AdminListingState {}

class FetchingLoading extends AdminListingState {}

class SubmittingState extends AdminListingState {}

// Loaded States
class ListingLoaded extends AdminListingState {
  final List<Listing> listings;

  const ListingLoaded(this.listings);

  @override
  List<Object> get props => [listings];
}

class ListingError extends AdminListingState {
  final String message;

  const ListingError(this.message);

  @override
  List<Object> get props => [message];
}


// Success States
class ListingCreated extends AdminListingState {
  final DateTime timestamp;

  const ListingCreated(this.timestamp);

  @override
  List<Object> get props => [timestamp];
}

class SuccessDeleted extends AdminListingState {
  final DateTime timestamp;

  const SuccessDeleted(this.timestamp);

  @override
  List<Object> get props => [timestamp];
}

class SuccessUpdateDorm extends AdminListingState {
  final DateTime timestamp;

  const SuccessUpdateDorm(this.timestamp);

  @override
  List<Object> get props => [timestamp];
}

class SuccessToggle extends AdminListingState {
  final DateTime timestamp;

  const SuccessToggle(this.timestamp);

  @override
  List<Object> get props => [timestamp];
}

class UpdateDormError extends AdminListingState {
  final String message;

  const UpdateDormError(this.message);

  @override
  List<Object> get props => [message];
}

class ListingCreationError extends AdminListingState {
  final String message;

  const ListingCreationError(this.message);

  @override
  List<Object> get props => [message];
}

class DeletionError extends AdminListingState {
  final String message;

  const DeletionError(this.message);

  @override
  List<Object> get props => [message];
}

class ToggleError extends AdminListingState {
  final String message;

  const ToggleError(this.message);

  @override
  List<Object> get props => [message];
}

class CardSelectedState extends AdminListingState {
  final Listing listing;
  final String selectedCard;

  const CardSelectedState(this.listing, this.selectedCard);

  @override
  List<Object> get props => [listing, selectedCard];
}

class AcceptListingSuccess extends AdminListingState {
  final DateTime date;

  const AcceptListingSuccess(this.date);

  @override
  List<Object> get props => [date];
}

class RejectListingSuccess extends AdminListingState {
  final DateTime date;

  const RejectListingSuccess(this.date);

  @override
  List<Object> get props => [date];
}

class AcceptRejectError extends AdminListingState {
  final String error;

  const AcceptRejectError(this.error);

  @override
  List<Object> get props => [error];
}
