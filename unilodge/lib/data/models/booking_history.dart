import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/listing.dart';

class BookingHistory extends Equatable {
  final Listing listing;
  final String status;
  final String createdAt;

  const BookingHistory({
    required this.listing,
    required this.status,
    required this.createdAt,
  });

  factory BookingHistory.fromJson(Map<String, dynamic> json) {
    return BookingHistory(
      listing: Listing.fromJson(json['listing_id']),
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }
  // Map<String, dynamic> toJson() {
  //   return {
  //     '_id': id,
  //     'userIds': user_ids,
  //     'profile': profile,
  //     'chatName': chat_name,
  //     'wasActive': was_active,
  //     'lastMessage': last_message,
  //   };
  // }

  @override
  List<Object> get props => [listing, status, createdAt];
}
