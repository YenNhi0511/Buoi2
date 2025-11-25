import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/entities/review.dart';
import '../../../../core/services/image_service.dart';
import '../../domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final FirebaseFirestore _firestore;
  final ImageService _imageService;

  ReviewRepositoryImpl({
    FirebaseFirestore? firestore,
    ImageService? imageService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _imageService = imageService ?? ImageService();

  @override
  Stream<List<Review>> getReviewsStream(String restaurantId) {
    return _firestore
        .collection('reviews')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList(),
        );
  }

  @override
  Future<List<Review>> getReviewsForRestaurant(String restaurantId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList();
  }

  @override
  Future<Review?> getReviewById(String id) async {
    final doc = await _firestore.collection('reviews').doc(id).get();
    if (doc.exists) {
      return Review.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<Review> addReview(Review review) async {
    final docRef = _firestore.collection('reviews').doc();
    final reviewWithId = review.copyWith(id: docRef.id);

    await docRef.set(reviewWithId.toJson());
    return reviewWithId;
  }

  @override
  Future<Review> updateReview(Review review) async {
    await _firestore
        .collection('reviews')
        .doc(review.id)
        .update(review.toJson());

    return review;
  }

  @override
  Future<void> deleteReview(String id) async {
    // Get review to delete associated images
    final review = await getReviewById(id);
    if (review != null && review.imageUrls.isNotEmpty) {
      // Delete images from storage
      for (final imageUrl in review.imageUrls) {
        try {
          await _imageService.deleteFromFirebaseStorage(imageUrl);
        } catch (e) {
          // Continue even if image deletion fails
          print('Failed to delete image: $e');
        }
      }
    }
    await _firestore.collection('reviews').doc(id).delete();
  }

  @override
  Future<List<Review>> getUserReviews(String userId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList();
  }

  @override
  Future<List<Review>> getReviewsWithImages(String restaurantId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('restaurantId', isEqualTo: restaurantId)
        .where('imageUrls', isNotEqualTo: [])
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList();
  }

  @override
  Future<double> calculateAverageRating(String restaurantId) async {
    final reviews = await getReviewsForRestaurant(restaurantId);

    if (reviews.isEmpty) return 0.0;

    final totalRating = reviews.fold<double>(
      0,
      (sum, review) => sum + review.rating,
    );
    return totalRating / reviews.length;
  }
}
