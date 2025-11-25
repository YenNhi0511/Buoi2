import '../../../../core/entities/restaurant.dart';

abstract class RestaurantRepository {
  /// Stream of all restaurants
  Stream<List<Restaurant>> get restaurantsStream;

  /// Get all restaurants
  Future<List<Restaurant>> getRestaurants();

  /// Get restaurant by ID
  Future<Restaurant?> getRestaurantById(String id);

  /// Add new restaurant
  Future<Restaurant> addRestaurant(Restaurant restaurant);

  /// Update restaurant
  Future<Restaurant> updateRestaurant(Restaurant restaurant);

  /// Delete restaurant
  Future<void> deleteRestaurant(String id);

  /// Search restaurants by name or category
  Future<List<Restaurant>> searchRestaurants(String query);

  /// Get restaurants by category
  Future<List<Restaurant>> getRestaurantsByCategory(String category);

  /// Get nearby restaurants
  Future<List<Restaurant>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  });
}
