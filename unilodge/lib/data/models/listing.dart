class Listing {
  final String? id;
  final String? property_name;
  final String? address; // Combined address for display purposes
  final String? city;
  final String? street;
  final String? barangay;
  final String? house_number;
  final String? zip_code;
  final String? price;
  final String? description;
  final String? leastTerms;
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
    this.city,
    this.street,
    this.barangay,
    this.house_number,
    this.zip_code,
    this.price,
    this.description,
    this.leastTerms,
    this.ownerInfo,
    this.amenities,
    this.utilities,
    this.imageUrl,
    this.rating,
    this.selectedPropertyType,
  });

  // Getter for the combined address
  String get adddress {
    return '$house_number $street, $barangay, $city, $zip_code';
  }

  Listing copyWith({
    String? id,
    String? property_name,
    String? address,
    String? city,
    String? street,
    String? barangay,
    String? house_number,
    String? zip_code,
    String? price,
    String? description,
    String? leastTerms,
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
      city: city ?? this.city,
      street: street ?? this.street,
      barangay: barangay ?? this.barangay,
      house_number: house_number ?? this.house_number,
      zip_code: zip_code ?? this.zip_code,
      price: price ?? this.price,
      description: description ?? this.description,
      leastTerms: leastTerms ?? this.leastTerms,
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
      city: json['city'],
      street: json['street'],
      barangay: json['barangay'],
      house_number: json['house_number'],
      zip_code: json['zip_code'],
      price: json['price'],
      description: json['description'],
      ownerInfo: json['owner_info'],
      amenities: List<String>.from(json['amenities']),
      utilities: List<String>.from(json['utilities'] ?? []),
      imageUrl: json['image_url'],
      rating: json['rating'],
      selectedPropertyType: json['selectedPropertyType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'property_name': property_name,
      'city': city,
      'street': street,
      'barangay': barangay,
      'house_number': house_number,
      'zip_code': zip_code,
      'price': price,
      'description': description,
      'owner_info': ownerInfo,
      'amenities': amenities?.map((x) => x).toList(),
      'utilities': utilities?.map((x) => x).toList(),
      'image_url': imageUrl,
      'rating': rating,
      'selectedPropertyType': selectedPropertyType,
    };
  }
}
