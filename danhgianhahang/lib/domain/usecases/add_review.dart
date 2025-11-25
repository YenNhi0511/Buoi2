import '../entities/review.dart';
import '../repositories/restaurant_repository.dart';
import '../repositories/notification_repository.dart';

class AddReview {
  final RestaurantRepository restaurantRepository;
  final NotificationRepository notificationRepository;

  AddReview(this.restaurantRepository, this.notificationRepository);

  Future<void> call(
    Review review,
    List<String>? imagePaths,
    String restaurantName,
  ) async {
    // Upload images if any
    final List<String> imageUrls = [];
    if (imagePaths != null) {
      for (final path in imagePaths) {
        final url = await restaurantRepository.uploadReviewImage(path);
        imageUrls.add(url);
      }
    }

    // Create review with image URLs
    final reviewWithImages = Review(
      id: review.id,
      restaurantId: review.restaurantId,
      userId: review.userId,
      userName: review.userName,
      userPhotoUrl: review.userPhotoUrl,
      rating: review.rating,
      comment: review.comment,
      imageUrls: imageUrls,
      createdAt: review.createdAt,
    );

    await restaurantRepository.addReview(reviewWithImages);

    // Send notification about new review
    await notificationRepository.sendNewReviewNotification(
      restaurantName,
      review.userName,
    );
  }
}
