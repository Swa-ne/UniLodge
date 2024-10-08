import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/listing.dart';

abstract class ListingEvent extends Equatable {
  const ListingEvent();

  @override
  List<Object?> get props => [];
}

// Event to handle card selection
class SelectCardEvent extends ListingEvent {
  final String cardName;

  const SelectCardEvent(this.cardName);

  @override
  List<Object?> get props => [cardName];
}

// Event to update the entire Listing model
class UpdateListingEvent extends ListingEvent {
  final Listing updatedListing;

  const UpdateListingEvent(this.updatedListing);

  @override
  List<Object?> get props => [updatedListing];
}

// Event to update the amenities list
class UpdateAmenitiesEvent extends ListingEvent {
  final List<String> amenities;

  const UpdateAmenitiesEvent(this.amenities);

  @override
  List<Object?> get props => [amenities];
}

// Event to update the utilities list
class UpdateUtilitiesEvent extends ListingEvent {
  final List<String> utilities;

  const UpdateUtilitiesEvent(this.utilities);

  @override
  List<Object?> get props => [utilities];
}

// Event to select image files for the listing
// Keep this if image selection and upload are separate actions
class SelectImagesEvent extends ListingEvent {
  final List<File> images; // Updated for generic image selection

  const SelectImagesEvent(this.images);

  @override
  List<Object?> get props => [images];
}

// Event to handle image file upload and pass the associated listing data
class UploadImagesEvent extends ListingEvent {
  final List<File> images;  // Updated for generic image files
  final Listing listing;

  const UploadImagesEvent(this.images, this.listing);

  @override
  List<Object?> get props => [images, listing];
}
