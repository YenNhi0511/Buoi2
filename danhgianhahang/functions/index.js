// functions/index.js - FINAL FIXED VERSION
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// 1. Tự động tính average rating khi có review mới
exports.calculateAverageRating = functions.firestore
    .document('restaurants/{restaurantId}/reviews/{reviewId}')
    .onWrite(async (change, context) => {
      const restaurantId = context.params.restaurantId;

      const reviewsSnapshot = await admin.firestore()
          .collection('restaurants')
          .doc(restaurantId)
          .collection('reviews')
          .get();

      if (reviewsSnapshot.empty) {
        console.log('No reviews found for restaurant:', restaurantId);
        return null;
      }

      let totalRating = 0;
      let reviewCount = 0;

      reviewsSnapshot.forEach((doc) => {
        const data = doc.data();
        totalRating += data.rating || 0;
        reviewCount++;
      });

      const averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;

      await admin.firestore()
          .collection('restaurants')
          .doc(restaurantId)
          .update({
            rating: averageRating,
            reviewCount: reviewCount,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });

      console.log(
          'Updated restaurant ' + restaurantId + ': ' +
        'rating=' + averageRating.toFixed(1) + ', reviews=' + reviewCount,
      );

      return null;
    });

// 2. Gửi notification cho users đã favorite restaurant
exports.sendNewReviewNotification = functions.firestore
    .document('restaurants/{restaurantId}/reviews/{reviewId}')
    .onCreate(async (snap, context) => {
      const restaurantId = context.params.restaurantId;
      const reviewData = snap.data();
      const reviewAuthor = reviewData.userName || 'Someone';

      // Lấy thông tin restaurant
      const restaurantDoc = await admin.firestore()
          .collection('restaurants')
          .doc(restaurantId)
          .get();

      if (!restaurantDoc.exists) {
        console.log('Restaurant not found');
        return null;
      }

      const restaurantName = restaurantDoc.data().name;

      // Tìm tất cả users
      const usersSnapshot = await admin.firestore()
          .collection('users')
          .get();

      const notificationPromises = [];

      for (const userDoc of usersSnapshot.docs) {
        const userId = userDoc.id;

        // Check xem user có favorite restaurant này không
        const favoriteDoc = await admin.firestore()
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(restaurantId)
            .get();

        if (favoriteDoc.exists && userId !== reviewData.userId) {
          const userFcmToken = userDoc.data().fcmToken;

          if (userFcmToken) {
            const message = {
              notification: {
                title: 'New Review!',
                body: reviewAuthor + ' just reviewed ' + restaurantName,
              },
              data: {
                restaurantId: restaurantId,
                reviewId: context.params.reviewId,
                type: 'new_review',
              },
              token: userFcmToken,
            };

            notificationPromises.push(
                admin.messaging().send(message)
                    .then(() => {
                      console.log('Notification sent to user ' + userId);
                    })
                    .catch((error) => {
                      console.error('Error sending to ' + userId + ':', error);
                    }),
            );
          }
        }
      }

      await Promise.all(notificationPromises);
      console.log('Sent ' + notificationPromises.length + ' notifications');

      return null;
    });

// 3. Cleanup images khi xóa review
exports.cleanupReviewImages = functions.firestore
    .document('restaurants/{restaurantId}/reviews/{reviewId}')
    .onDelete(async (snap) => {
      const data = snap.data();
      const imageUrls = data.imageUrls || [];

      if (imageUrls.length === 0) {
        return null;
      }

      const bucket = admin.storage().bucket();
      const deletePromises = imageUrls.map(async (url) => {
        try {
          const parts = url.split('/o/');
          if (parts.length > 1) {
            const filePath = parts[1].split('?')[0];
            if (filePath) {
              const decodedPath = decodeURIComponent(filePath);
              await bucket.file(decodedPath).delete();
              console.log('Deleted image:', decodedPath);
            }
          }
        } catch (error) {
          console.error('Error deleting image:', url, error);
        }
      });

      await Promise.all(deletePromises);
      console.log('Cleaned up ' + imageUrls.length + ' images');

      return null;
    });

// 4. Tạo user profile khi đăng ký
exports.createUserProfile = functions.auth.user().onCreate(async (user) => {
  const uid = user.uid;
  const email = user.email;
  const displayName = user.displayName;
  const photoURL = user.photoURL;

  await admin.firestore()
      .collection('users')
      .doc(uid)
      .set({
        email: email,
        displayName: displayName || '',
        photoURL: photoURL || '',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        fcmToken: null,
      });

  console.log('User profile created for ' + uid);
  return null;
});

// 5. Update FCM token
exports.updateFcmToken = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be logged in',
    );
  }

  const userId = context.auth.uid;
  const fcmToken = data.fcmToken;

  if (!fcmToken) {
    throw new functions.https.HttpsError(
        'invalid-argument',
        'FCM token is required',
    );
  }

  await admin.firestore()
      .collection('users')
      .doc(userId)
      .update({
        fcmToken: fcmToken,
        fcmTokenUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

  console.log('FCM token updated for user ' + userId);

  return {success: true};
});