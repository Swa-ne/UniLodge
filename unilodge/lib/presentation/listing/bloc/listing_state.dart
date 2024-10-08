import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/listing.dart';

abstract class ListingState extends Equatable {
  const ListingState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ListingInitial extends ListingState {}

// State when a card is selected
class CardSelectedState extends ListingState {
  final Listing listing;
  final String cardName;

  const CardSelectedState(this.listing, this.cardName);
  String get selectedCard => cardName;

  @override
  List<Object?> get props => [listing, cardName];
}

// State when image upload is in progress
class ImageUploadInProgress extends ListingState {}

// State when images have been uploaded successfully
class ImagesUploadedState extends ListingState {
  final List<String> uploadedImagePaths;

  const ImagesUploadedState(this.uploadedImagePaths);

  @override
  List<Object?> get props => [uploadedImagePaths];
}

// State when image upload fails
class ImageUploadFailure extends ListingState {
  final String error;

  const ImageUploadFailure(this.error);

  @override
  List<Object?> get props => [error];
}


