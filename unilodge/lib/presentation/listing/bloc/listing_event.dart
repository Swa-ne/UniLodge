abstract class ListingEvent {
  const ListingEvent();
}

class SelectCardEvent extends ListingEvent {
  final String cardName;

  const SelectCardEvent(this.cardName);
}
