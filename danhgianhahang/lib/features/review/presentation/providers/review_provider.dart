import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/entities/review.dart';
import '../../../../core/services/image_service.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/usecases/review_usecases.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewRepository _reviewRepository;
  final ImageService _imageService;
  final AddReview _addReview;
  final UpdateReview _updateReview;
  final DeleteReview _deleteReview;
  final GetReviewsForRestaurant _getReviewsForRestaurant;
  final GetUserReviews _getUserReviews;
  final GetReviewsWithImages _getReviewsWithImages;
  final CalculateAverageRating _calculateAverageRating;

  ReviewProvider({
    required ReviewRepository reviewRepository,
    required ImageService imageService,
  }) : _reviewRepository = reviewRepository,
       _imageService = imageService,
       _addReview = AddReview(reviewRepository),
       _updateReview = UpdateReview(reviewRepository),
       _deleteReview = DeleteReview(reviewRepository),
       _getReviewsForRestaurant = GetReviewsForRestaurant(reviewRepository),
       _getUserReviews = GetUserReviews(reviewRepository),
       _getReviewsWithImages = GetReviewsWithImages(reviewRepository),
       _calculateAverageRating = CalculateAverageRating(reviewRepository);

  // State
  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _error;
  List<File> _selectedImages = [];
  double _averageRating = 0.0;

  // Getters
  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<File> get selectedImages => _selectedImages;
  double get averageRating => _averageRating;

  // Load reviews for a restaurant
  Future<void> loadReviews(String restaurantId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reviews = await _getReviewsForRestaurant(restaurantId);
      _averageRating = await _calculateAverageRating(restaurantId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load user's reviews
  Future<void> loadUserReviews(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reviews = await _getUserReviews(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add selected image
  void addSelectedImage(File image) {
    _selectedImages.add(image);
    notifyListeners();
  }

  // Remove selected image
  void removeSelectedImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      notifyListeners();
    }
  }

  // Clear selected images
  void clearSelectedImages() {
    _selectedImages.clear();
    notifyListeners();
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final image = await _imageService.pickImage(ImageSource.gallery);
      if (image != null) {
        addSelectedImage(image);
      }
    } catch (e) {
      _error = 'Không thể chọn ảnh: $e';
      notifyListeners();
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final image = await _imageService.pickImage(ImageSource.camera);
      if (image != null) {
        addSelectedImage(image);
      }
    } catch (e) {
      _error = 'Không thể chụp ảnh: $e';
      notifyListeners();
    }
  }

  // Pick multiple images
  Future<void> pickMultipleImages() async {
    try {
      final images = await _imageService.pickMultipleImages();
      for (final image in images) {
        addSelectedImage(image);
      }
    } catch (e) {
      _error = 'Không thể chọn ảnh: $e';
      notifyListeners();
    }
  }

  // Submit review with images
  Future<bool> submitReview({
    required String restaurantId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required double rating,
    required String comment,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Upload images first
      List<String> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        imageUrls = await _imageService.uploadMultipleImages(
          _selectedImages,
          'reviews/$restaurantId',
        );
      }

      // Create review
      final review = Review(
        id: '', // Will be set by repository
        restaurantId: restaurantId,
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        rating: rating,
        comment: comment,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isVerified: false,
      );

      // Save review
      final savedReview = await _addReview(review);

      // Clear selected images
      clearSelectedImages();

      // Reload reviews
      await loadReviews(restaurantId);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Không thể gửi đánh giá: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete review
  Future<bool> deleteReview(String reviewId, String restaurantId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _deleteReview(reviewId);
      await loadReviews(restaurantId);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _error = 'Không thể xóa đánh giá: $e';
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
