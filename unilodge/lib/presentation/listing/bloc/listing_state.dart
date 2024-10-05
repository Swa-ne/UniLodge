abstract class ListingState {
  const ListingState();
}

class ListingInitial extends ListingState {}

class CardSelectedState extends ListingState {
  final String selectedCard;

  CardSelectedState(this.selectedCard);
}
