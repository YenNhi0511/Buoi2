import '../../../../core/entities/review.dart';
import '../repositories/review_repository.dart';
import '../../../../domain/repositories/notification_repository.dart';

class AddReview {
  final ReviewRepository repository;
  final NotificationRepository notificationRepository;

  AddReview(this.repository, this.notificationRepository);

  Future<Review> call(Review review, String restaurantName) async {
    final addedReview = await repository.addReview(review);

    // Send notification
    await notificationRepository.sendNewReviewNotification(
      restaurantName,
      review.userName,
    );

    return addedReview;
  }
}
