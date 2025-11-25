import '../../core/notification_service.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService notificationService;

  NotificationRepositoryImpl({required this.notificationService});

  @override
  Future<void> sendNewReviewNotification(
    String restaurantName,
    String userName,
  ) async {
    // Show local notification for demo
    await notificationService.showNotification(
      title: 'New Review Added!',
      body: '$userName just reviewed $restaurantName',
      payload: 'review_added',
    );

    print('New review notification sent: $userName reviewed $restaurantName');

    // In production, you would call Cloud Functions to send FCM to all users:
    /*
    // Call Cloud Function
    final functions = FirebaseFunctions.instance;
    final result = await functions
        .httpsCallable('sendNewReviewNotification')
        .call({
          'restaurantName': restaurantName,
          'userName': userName,
        });
    */
  }
}
