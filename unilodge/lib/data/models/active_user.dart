import 'package:equatable/equatable.dart';
import 'package:unilodge/data/models/user.dart';

class ActiveUserModel extends Equatable {
  final String id;
  final UserModel userId;
  final String active;
  final String fullName;

  const ActiveUserModel({
    required this.id,
    required this.userId,
    required this.active,
    required this.fullName,
  });

  factory ActiveUserModel.fromJson(Map<String, dynamic> json) {
    return ActiveUserModel(
      id: json['_id'],
      userId: UserModel.fromJson(json['userId']),
      active: json['active'],
      fullName: json['fullName'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'active': active,
      'fullName': fullName,
    };
  }

  @override
  List<Object> get props => [id, userId, active, fullName];
}
