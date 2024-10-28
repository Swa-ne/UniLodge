import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/listing.dart';

abstract class ListingState extends Equatable {
  const ListingState();

  @override
  List<Object> get props => [];
}

class ListingLoading extends ListingState {}

class FetchingLoading extends ListingState {}

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

class UpdateDormError extends ListingState {
  final String message;

  const UpdateDormError(this.message);

  @override
  List<Object> get props => [message];
}

class ListingCreated extends ListingState {
  final DateTime date;

  const ListingCreated(this.date);

  @override
  List<Object> get props => [date];
}

class SuccessDeleted extends ListingState {
  final DateTime date;

  const SuccessDeleted(this.date);

  @override
  List<Object> get props => [date];
}

class SuccessUpdateDorm extends ListingState {
  final DateTime date;

  const SuccessUpdateDorm(this.date);

  @override
  List<Object> get props => [date];
}

class SuccessToggle extends ListingState {
  final DateTime date;

  const SuccessToggle(this.date);

  @override
  List<Object> get props => [date];
}

class ListingCreationError extends ListingState {
  final String error;

  const ListingCreationError(this.error);

  @override
  List<Object> get props => [error];
}

class DeletionError extends ListingState {
  final String error;

  const DeletionError(this.error);

  @override
  List<Object> get props => [error];
}

class ToggleError extends ListingState {
  final String error;

  const ToggleError(this.error);

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

class SubmittingState extends ListingState {}

class IsValidLandlordSuccess extends ListingState {
  final bool isValid;

  const IsValidLandlordSuccess(this.isValid);

  @override
  List<Object> get props => [isValid];
}

class IsValidLandlordError extends ListingState {
  final String error;

  const IsValidLandlordError(this.error);

  @override
  List<Object> get props => [error];
}

class IsValidLandlordsSuccess extends ListingState {
  final bool isValid;

  const IsValidLandlordsSuccess(this.isValid);

  @override
  List<Object> get props => [isValid];
}

class IsValidLandlordsError extends ListingState {
  final String error;

  const IsValidLandlordsError(this.error);

  @override
  List<Object> get props => [error];
}
