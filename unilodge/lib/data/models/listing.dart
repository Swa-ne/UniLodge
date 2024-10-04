class Listing {
  final String id;
  final String property_name;
  final String address;
  final String price;
  final String description;
  final String ownerInfo;
  final List<String> amenities;
  final String imageUrl;
  final int rating;

  Listing(
      {required this.id,
      required this.property_name,
      required this.address,
      required this.price,
      required this.description,
      required this.ownerInfo,
      required this.amenities,
      required this.imageUrl,
      required this.rating});
}
