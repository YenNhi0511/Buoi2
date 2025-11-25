import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'lib/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  try {
    // Kiểm tra collection reviews
    final reviewsSnapshot = await firestore.collection('reviews').get();
    print('Total reviews: ${reviewsSnapshot.docs.length}');

    if (reviewsSnapshot.docs.isEmpty) {
      print('No reviews found. Creating sample data...');

      // Tạo sample restaurant
      await firestore.collection('restaurants').doc('sample_restaurant').set({
        'name': 'Sample Restaurant',
        'description': 'A sample restaurant for testing',
        'imageUrl': 'https://example.com/image.jpg',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Tạo sample review
      await firestore.collection('reviews').add({
        'restaurantId': 'sample_restaurant',
        'userId': 'test_user',
        'rating': 5.0,
        'comment': 'Great food and service!',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Sample data created successfully!');
    } else {
      for (var doc in reviewsSnapshot.docs) {
        print('Review: ${doc.id} - ${doc.data()}');
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}
