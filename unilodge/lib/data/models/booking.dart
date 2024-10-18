import 'package:unilodge/data/models/user.dart';

class Booking {
  final String id;
  final UserModel userId;
  final String propertyType;
  final double price;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.propertyType,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      userId: UserModel.fromJson(json['user_id']),
      propertyType: json['propertyType'],
      price: json['price'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'propertyType': propertyType,
      'price': price,
      'status': status,
    };
  }
}
