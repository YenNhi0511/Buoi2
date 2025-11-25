import 'package:flutter/foundation.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/usecases/get_restaurants.dart';

class RestaurantProvider extends ChangeNotifier {
  final GetRestaurants getRestaurantsUseCase;

  RestaurantProvider({required this.getRestaurantsUseCase});

  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  String? _error;

  List<Restaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRestaurants() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _restaurants = await getRestaurantsUseCase();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  List<Restaurant> searchRestaurants(String query) {
    if (query.isEmpty) return _restaurants;

    return _restaurants
        .where(
          (r) =>
              r.name.toLowerCase().contains(query.toLowerCase()) ||
              r.category.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
