import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.restaurantId,
    required super.userId,
    required super.userName,
    required super.userPhotoUrl,
    required super.rating,
    required super.comment,
    required super.imageUrls,
    required super.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhotoUrl: map['userPhotoUrl'] ?? '',
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      imageUrls: map['imageUrl'] != null ? [map['imageUrl']] : [],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'imageUrl': imageUrls.isNotEmpty ? imageUrls.first : null,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
