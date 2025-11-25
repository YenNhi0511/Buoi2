import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/restaurant_repository_impl.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/restaurant_repository.dart';
import '../domain/repositories/notification_repository.dart';
import '../features/review/domain/usecases/add_review.dart'
    as features_add_review;
import '../domain/usecases/get_restaurants.dart';
import '../features/review/data/repositories/review_repository_impl.dart';
import '../features/review/domain/repositories/review_repository.dart';
import '../features/review/domain/usecases/review_usecases.dart';
import '../features/review/presentation/providers/review_provider.dart';
import '../presentation/providers/auth_provider.dart' as presentation_auth;
import '../presentation/providers/restaurant_provider.dart';
import 'database_helper.dart';
import 'services/image_service.dart';
import 'notification_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DatabaseHelper());

  // Services
  sl.registerLazySingleton(() => NotificationService());
  sl.registerLazySingleton(() => ImageService());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: sl()),
  );

  sl.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(httpClient: sl(), databaseHelper: sl()),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(notificationService: sl()),
  );

  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(firestore: sl(), imageService: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRestaurants(sl()));
  sl.registerLazySingleton(() => features_add_review.AddReview(sl(), sl()));
  sl.registerLazySingleton(() => UpdateReview(sl()));
  sl.registerLazySingleton(() => DeleteReview(sl()));
  sl.registerLazySingleton(() => GetReviewsForRestaurant(sl()));
  sl.registerLazySingleton(() => GetUserReviews(sl()));
  sl.registerLazySingleton(() => GetReviewsWithImages(sl()));
  sl.registerLazySingleton(() => CalculateAverageRating(sl()));

  // Providers
  sl.registerFactory(
    () => presentation_auth.AuthProvider(authRepository: sl()),
  );
  sl.registerFactory(() => RestaurantProvider(getRestaurantsUseCase: sl()));
  sl.registerFactory(
    () => ReviewProvider(reviewRepository: sl(), imageService: sl()),
  );
}
