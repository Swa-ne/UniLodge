part of 'renter_bloc.dart';

abstract class RenterState extends Equatable {
  const RenterState();

  @override
  List<Object> get props => [];
}
class RenterInitial extends RenterState {}

class DormsLoaded extends RenterState {
  final List<SavedDorm> savedDorms;

  const DormsLoaded(this.savedDorms);

  @override
  List<Object> get props => [savedDorms];
}

class DormsError extends RenterState {
  final String message;

  const DormsError(this.message);

  @override
  List<Object> get props => [message];
}

class ReviewPosting extends RenterState {}

class ReviewPosted extends RenterState {
  final String successMessage;

  const ReviewPosted(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class ReviewError extends RenterState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object> get props => [message];
}

class DormSaving extends RenterState {}

class DormSaved extends RenterState {
  final String successMessage;

  const DormSaved(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class DormSaveError extends RenterState {
  final String message;

  const DormSaveError(this.message);

  @override
  List<Object> get props => [message];
}
