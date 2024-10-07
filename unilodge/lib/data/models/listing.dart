class Listing {
  final String? id;
  final String? property_name;
  final String? address;
  final String? price;
  final String? description;
  final String? leaseTerms;
  final String? ownerInfo;
  final List<String>? amenities;
  final List<String>? utilities;
  final String? imageUrl;
  final int? rating;
  final String? selectedPropertyType;

  Listing({
    this.id,
    this.property_name,
    this.address,
    this.price,
    this.description,
    this.leaseTerms,
    this.ownerInfo,
    this.amenities,
    this.utilities,
    this.imageUrl,
    this.rating,
    this.selectedPropertyType,
  });

  Listing copyWith({
    String? id,
    String? property_name,
    String? address,
    String? price,
    String? description,
    String? leaseTerms,
    String? ownerInfo,
    List<String>? amenities,
    List<String>? utilities,
    String? imageUrl,
    int? rating,
    String? selectedPropertyType,
  }) {
    return Listing(
      id: id ?? this.id,
      property_name: property_name ?? this.property_name,
      address: address ?? this.address,
      price: price ?? this.price,
      description: description ?? this.description,
      leaseTerms: leaseTerms ?? this.leaseTerms,
      ownerInfo: ownerInfo ?? this.ownerInfo,
      amenities: amenities ?? this.amenities,
      utilities: utilities ?? this.utilities,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      selectedPropertyType: selectedPropertyType ?? this.selectedPropertyType,
    );
  }

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
}
