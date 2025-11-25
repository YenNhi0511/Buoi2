import '../../../../core/entities/review.dart';
import '../repositories/review_repository.dart';

class AddReview {
  final ReviewRepository repository;

  AddReview(this.repository);

  Future<Review> call(Review review) async {
    return await repository.addReview(review);
  }
}

class UpdateReview {
  final ReviewRepository repository;

  UpdateReview(this.repository);

  Future<Review> call(Review review) async {
    return await repository.updateReview(review);
  }
}

class DeleteReview {
  final ReviewRepository repository;

  DeleteReview(this.repository);

  Future<void> call(String reviewId) async {
    return await repository.deleteReview(reviewId);
  }
}

class GetReviewsForRestaurant {
  final ReviewRepository repository;

  GetReviewsForRestaurant(this.repository);

  Future<List<Review>> call(String restaurantId) async {
    return await repository.getReviewsForRestaurant(restaurantId);
  }
}

class GetUserReviews {
  final ReviewRepository repository;

  GetUserReviews(this.repository);

  Future<List<Review>> call(String userId) async {
    return await repository.getUserReviews(userId);
  }
}

class GetReviewsWithImages {
  final ReviewRepository repository;

  GetReviewsWithImages(this.repository);

  Future<List<Review>> call(String restaurantId) async {
    return await repository.getReviewsWithImages(restaurantId);
  }
}

class CalculateAverageRating {
  final ReviewRepository repository;

  CalculateAverageRating(this.repository);

  Future<double> call(String restaurantId) async {
    return await repository.calculateAverageRating(restaurantId);
  }
}
