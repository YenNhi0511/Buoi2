import '../../../../core/entities/review.dart';

abstract class ReviewRepository {
  /// Stream of reviews for a restaurant
  Stream<List<Review>> getReviewsStream(String restaurantId);

  /// Get all reviews for a restaurant
  Future<List<Review>> getReviewsForRestaurant(String restaurantId);

  /// Get review by ID
  Future<Review?> getReviewById(String id);

  /// Add new review
  Future<Review> addReview(Review review);

  /// Update review
  Future<Review> updateReview(Review review);

  /// Delete review
  Future<void> deleteReview(String id);

  /// Get user's reviews
  Future<List<Review>> getUserReviews(String userId);

  /// Get reviews with images
  Future<List<Review>> getReviewsWithImages(String restaurantId);

  /// Calculate average rating for restaurant
  Future<double> calculateAverageRating(String restaurantId);
}
