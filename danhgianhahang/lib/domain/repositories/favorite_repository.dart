// lib/domain/repositories/favorite_repository.dart
abstract class FavoriteRepository {
  Future<void> addFavorite(String userId, String restaurantId);
  Future<void> removeFavorite(String userId, String restaurantId);
  Future<List<String>> getFavoriteIds(String userId);
  Stream<List<String>> getFavoriteIdsStream(String userId);
}

// lib/data/repositories/favorite_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FirebaseFirestore _firestore;

  FavoriteRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addFavorite(String userId, String restaurantId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(restaurantId)
        .set({
      'restaurantId': restaurantId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFavorite(String userId, String restaurantId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(restaurantId)
        .delete();
  }

  @override
  Future<List<String>> getFavoriteIds(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  @override
  Stream<List<String>> getFavoriteIdsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }
}

// lib/presentation/providers/favorite_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/repositories/favorite_repository.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository _repository;
  Set<String> _favoriteIds = {};
  bool _isLoading = false;
  String? _error;

  FavoriteProvider({required FavoriteRepository repository})
      : _repository = repository;

  Set<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool isFavorite(String restaurantId) => _favoriteIds.contains(restaurantId);

  Future<void> loadFavorites(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final ids = await _repository.getFavoriteIds(userId);
      _favoriteIds = Set.from(ids);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String userId, String restaurantId) async {
    try {
      if (_favoriteIds.contains(restaurantId)) {
        await _repository.removeFavorite(userId, restaurantId);
        _favoriteIds.remove(restaurantId);
      } else {
        await _repository.addFavorite(userId, restaurantId);
        _favoriteIds.add(restaurantId);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}