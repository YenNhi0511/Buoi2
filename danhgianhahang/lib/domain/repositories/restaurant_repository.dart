import '../entities/restaurant.dart';
import '../entities/review.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getRestaurants();
  Future<Restaurant> getRestaurantById(String id);
  Future<List<Review>> getReviewsByRestaurantId(String restaurantId);
  Future<void> addReview(Review review);
  Future<String> uploadReviewImage(String imagePath);
}
