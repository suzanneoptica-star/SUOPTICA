
class Review {
  final String id;
  final String userName;
  final String userImageUrl;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.userName,
    required this.userImageUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map, String id) {
    return Review(
      id: id,
      userName: map['userName'] ?? 'Anónimo',
      userImageUrl: map['userImageUrl'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      comment: map['comment'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}
