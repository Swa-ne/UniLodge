class UserProfileModel {
  // final String id;
  final String fullName;
  final String username;
  final String profilePictureUrl; 
  final String personalEmail;
  final String personalNumber;
  final DateTime birthday;

  UserProfileModel({
    // required this.id,
    required this.fullName,
    required this.username,
    required this.profilePictureUrl,  
    required this.personalEmail,
    required this.personalNumber,
    required this.birthday,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      // id: json['_id'],
      fullName: json['full_name'],
      username: json['username'],
      profilePictureUrl: json['profile_picture_url'],
      personalEmail: json['personal_email'],
      personalNumber: json['personal_number'],
      birthday: DateTime.parse(json['birthday']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // '_id': id,
      'full_name': fullName,
      'username': username,
      'profile_picture_url': profilePictureUrl,
      'personal_email': personalEmail,
      'personal_number': personalNumber,
      'birthday': birthday.toIso8601String(),
    };
  }
}
