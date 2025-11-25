abstract class NotificationRepository {
  Future<void> sendNewReviewNotification(
    String restaurantName,
    String userName,
  );
}
