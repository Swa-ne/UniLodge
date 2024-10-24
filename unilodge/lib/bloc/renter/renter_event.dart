part of 'renter_bloc.dart';

abstract class RenterEvent extends Equatable {
  const RenterEvent();

  @override
  List<Object> get props => [];
}

class FetchSavedDorms extends RenterEvent {
  
}

class FetchAllDorms extends RenterEvent {}

class FetchAllDormsByType extends RenterEvent {
  final String listingType;

  const FetchAllDormsByType(this.listingType);
  @override
  List<Object> get props => [listingType];
}

class PostReview extends RenterEvent {
  final String userId;
  final String dormId;
  final int stars;
  final String comment;

  const PostReview(this.userId, this.dormId, this.stars, this.comment);

  @override
  List<Object> get props => [userId, dormId, stars, comment];
}


class SaveDorm extends RenterEvent {
  final String dormId;

  const SaveDorm(this.dormId);

  @override
  List<Object> get props => [dormId];
}

class DeleteSavedDorm extends RenterEvent {
  final String dormId;

  const DeleteSavedDorm(this.dormId);

  @override
  List<Object> get props => [dormId];
}

