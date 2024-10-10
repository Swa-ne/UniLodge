class Listing {
  final String? id;
  final String? owner_id;
  final String? property_name;
  final String? selectedPropertyType;
  final String? city;
  final String? street;
  final String? barangay;
  final String? house_number;
  final String? zip_code;
  final int? lat;
  final int? lng;
  final int? available_rooms;
  final String? price;
  final String? description;
  final String? leastTerms;
  final List<String>? amenities;
  final List<String>? utilities;
  final List<String>? imageUrl;
  final int? rating;
  final String? address;
  final bool? isAvailable;
  final String? createdAt;

  Listing({
    this.id,
    this.owner_id,
    this.property_name,
    this.address,
    this.city,
    this.street,
    this.barangay,
    this.house_number,
    this.zip_code,
    this.lat,
    this.lng,
    this.available_rooms,
    this.price,
    this.description,
    this.leastTerms,
    this.amenities,
    this.utilities,
    this.imageUrl,
    this.rating,
    this.selectedPropertyType,
    this.isAvailable,
    this.createdAt,
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
    String? owner_id,
    List<String>? amenities,
    List<String>? utilities,
    List<String>? imageUrl,
    int? rating,
    String? selectedPropertyType,
    bool? isAvailable,
    String? createdAt,
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
      owner_id: owner_id ?? this.owner_id,
      amenities: amenities ?? this.amenities,
      utilities: utilities ?? this.utilities,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      selectedPropertyType: selectedPropertyType ?? this.selectedPropertyType,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['_id'],
      property_name: json['property_name'],
      city: json["location"]['city'],
      street: json["location"]['street'],
      barangay: json["location"]['barangay'],
      house_number: json["location"]['house_number'],
      zip_code: "${json["location"]['zip_code']}",
      // lat: json["location"]["coordinates"]['lat'],
      // lng: json["location"]["coordinates"]['lng'],
      available_rooms: json['available_rooms'],
      price: "${json['price']}",
      description: json['description'],
      owner_id: json['owner_id'],
      amenities: List<String>.from(json['amenities']),
      utilities: List<String>.from(json['utilities']),
      imageUrl: (json['imageUrl'] as List<dynamic>)
          .map((image) => image['url'] as String)
          .toList(),
      rating: json['rating'],
      selectedPropertyType: json['type'],
      isAvailable: json['isAvailable'],
      createdAt: "${json['createdAt']}",
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
      'available_rooms': available_rooms,
      'price': price,
      'description': description,
      'owner_info': owner_id,
      'amenities': amenities?.map((x) => x).toList(),
      'utilities': utilities?.map((x) => x).toList(),
      'imageUrl': imageUrl?.map((x) => x).toList(),
      'rating': rating,
      'type': selectedPropertyType,
    };
  }
}
