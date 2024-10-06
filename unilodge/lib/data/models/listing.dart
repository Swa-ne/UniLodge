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

  Listing({
    required this.id,
    required this.property_name,
    required this.address,
    required this.price,
    required this.description,
    required this.ownerInfo,
    required this.amenities,
    required this.imageUrl,
    required this.rating,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['_id'],
      property_name: json['property_name'],
      address: json['address'],
      price: json['price'],
      description: json['description'],
      ownerInfo: json['owner_info'],
      amenities: List<String>.from(json['amenities']),
      imageUrl: json['image_url'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'property_name': property_name,
      'address': address,
      'price': price,
      'description': description,
      'owner_info': ownerInfo,
      'amenities': amenities,
      'image_url': imageUrl,
      'rating': rating,
    };
  }

  @override
  List<Object> get props => [
        id,
        property_name,
        address,
        price,
        description,
        ownerInfo,
        amenities,
        imageUrl,
        rating
      ];
}
