import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/database_helper.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../models/restaurant_model.dart';
import '../models/review_model.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final http.Client httpClient;
  final DatabaseHelper databaseHelper;

  // ImgBB API Key - bạn cần đăng ký tại https://imgbb.com/ để lấy key miễn phí
  // Key demo này có thể không hoạt động, hãy thay bằng key thật của bạn
  static const String _imgbbApiKey = '3c80e8c592b06e6f5f49d996b8689d20';

  RestaurantRepositoryImpl({
    required this.httpClient,
    required this.databaseHelper,
  });

  @override
  Future<List<Restaurant>> getRestaurants() async {
    final db = await databaseHelper.database;
    final maps = await db.query('restaurants', orderBy: 'rating DESC');

    return maps.map((map) => RestaurantModel.fromMap(map)).toList();
  }

  @override
  Future<Restaurant> getRestaurantById(String id) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'restaurants',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return RestaurantModel.fromMap(maps.first);
    } else {
      throw Exception('Restaurant not found');
    }
  }

  @override
  Future<List<Review>> getReviewsByRestaurantId(String restaurantId) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      'reviews',
      where: 'restaurantId = ?',
      whereArgs: [restaurantId],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => ReviewModel.fromMap(map)).toList();
  }

  @override
  Future<void> addReview(Review review) async {
    final db = await databaseHelper.database;
    final reviewModel = ReviewModel(
      id: review.id,
      restaurantId: review.restaurantId,
      userId: review.userId,
      userName: review.userName,
      userPhotoUrl: review.userPhotoUrl,
      rating: review.rating,
      comment: review.comment,
      imageUrls: review.imageUrls,
      createdAt: review.createdAt,
    );

    await db.insert('reviews', reviewModel.toMap());

    // Update restaurant rating and count
    await _updateRestaurantRating(review.restaurantId);
  }

  Future<void> _updateRestaurantRating(String restaurantId) async {
    final db = await databaseHelper.database;
    final reviews = await getReviewsByRestaurantId(restaurantId);

    if (reviews.isEmpty) return;

    final avgRating =
        reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    await db.update(
      'restaurants',
      {'rating': avgRating, 'reviewCount': reviews.length},
      where: 'id = ?',
      whereArgs: [restaurantId],
    );
  }

  @override
  Future<String> uploadReviewImage(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await httpClient.post(
        Uri.parse('https://api.imgbb.com/1/upload'),
        body: {'key': _imgbbApiKey, 'image': base64Image},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          return jsonResponse['data']['url'];
        } else {
          throw Exception('ImgBB upload failed: ${jsonResponse['error']}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
