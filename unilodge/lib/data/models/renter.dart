class Review {
  final String userId;
  final String dormId;
  final int stars;
  final String comment;

  Review({
    required this.userId,
    required this.dormId,
    required this.stars,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userId: json['user_id'],
      dormId: json['dorm_id'],
      stars: json['stars'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'dorm_id': dormId,
      'stars': stars,
      'comment': comment,
    };
  }

  List<Object> get props => [userId, dormId, stars, comment];
}

class SavedDorm {
  final String userId;
  final String dormId;

  SavedDorm({
    required this.userId,
    required this.dormId,
  });

  factory SavedDorm.fromJson(Map<String, dynamic> json) {
    return SavedDorm(
      userId: json['user_id'],
      dormId: json['dorm_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'dorm_id': dormId,
    };
  }

  List<Object> get props => [userId, dormId];
}
