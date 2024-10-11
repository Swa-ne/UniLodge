import 'package:unilodge/data/models/user.dart';

class Listing {
  final String? id;
  final UserModel? owner_id;
  final String? property_name;
  final String? selectedPropertyType;
  final String? city;
  final String? street;
  final String? barangay;
  final String? province;
  final String? region;
  final String? house_number;
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
    this.lat,
    this.lng,
    this.available_rooms,
    this.province,
    this.region,
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
    return '$house_number $street, $barangay, $city, $province, $region';
  }

  Listing copyWith({
    String? id,
    String? property_name,
    String? address,
    String? city,
    String? street,
    String? barangay,
    String? province,
    String? region,
    String? house_number,
    String? price,
    String? description,
    String? leastTerms,
    UserModel? owner_id,
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
      price: price ?? this.price,
      description: description ?? this.description,
      leastTerms: leastTerms ?? this.leastTerms,
      owner_id: owner_id ?? this.owner_id,
      amenities: amenities ?? this.amenities,
      utilities: utilities ?? this.utilities,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      province: province ?? this.province,
      region: region ?? this.region,
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
      // lat: json["location"]["coordinates"]['lat'],
      // lng: json["location"]["coordinates"]['lng'],
      available_rooms: json['available_rooms'],
      price: "${json['price']}",
      description: json['description'],
      leastTerms: json['least_terms'],
      owner_id: UserModel.fromJson(json['owner_id']),
      amenities: List<String>.from(json['amenities']),
      utilities: List<String>.from(json['utilities']),
      imageUrl: (json['imageUrl'] as List<dynamic>)
          .map((image) => image['url'] as String)
          .toList(),
      rating: json['rating'],
      province: json["location"]['province'],
      region: json["location"]['region'],
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
      'available_rooms': available_rooms,
      'price': price,
      'description': description,
      'least_terms': leastTerms,
      'province': province,
      'region': region,
      'owner_info': owner_id,
      'amenities': amenities?.map((x) => x).toList(),
      'utilities': utilities?.map((x) => x).toList(),
      'imageUrl': imageUrl?.map((x) => x).toList(),
      'rating': rating,
      'type': selectedPropertyType,
    };
  }
}
