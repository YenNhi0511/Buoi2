const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Cloud Function để tự động tính average rating khi có review mới
exports.calculateAverageRating = functions.firestore
    .document('restaurants/{restaurantId}/reviews/{reviewId}')
    .onWrite(async (change, context) => {
        const restaurantId = context.params.restaurantId;

        // Lấy tất cả reviews của restaurant
        const reviewsSnapshot = await admin.firestore()
            .collection('restaurants')
            .doc(restaurantId)
            .collection('reviews')
            .get();

        if (reviewsSnapshot.empty) {
            console.log('No reviews found for restaurant:', restaurantId);
            return null;
        }

        // Tính average rating
        let totalRating = 0;
        let reviewCount = 0;

        reviewsSnapshot.forEach(doc => {
            const data = doc.data();
            totalRating += data.rating || 0;
            reviewCount++;
        });

        const averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;

        // Cập nhật average rating và review count cho restaurant
        await admin.firestore()
            .collection('restaurants')
            .doc(restaurantId)
            .update({
                rating: averageRating,
                reviewCount: reviewCount,
                updatedAt: admin.firestore.FieldValue.serverTimestamp()
            });

        console.log(`Updated restaurant ${restaurantId}: rating=${averageRating.toFixed(1)}, reviews=${reviewCount}`);

        return null;
    });

// Cloud Function để cleanup images khi xóa review
exports.cleanupReviewImages = functions.firestore
    .document('restaurants/{restaurantId}/reviews/{reviewId}')
    .onDelete(async (snap, context) => {
        const data = snap.data();
        const imageUrls = data.imageUrls || [];

        if (imageUrls.length === 0) {
            return null;
        }

        // Xóa images từ Firebase Storage
        const bucket = admin.storage().bucket();
        const deletePromises = imageUrls.map(async (url) => {
            try {
                // Extract file path from Firebase Storage URL
                const filePath = url.split('/o/')[1]?.split('?')[0];
                if (filePath) {
                    const decodedPath = decodeURIComponent(filePath);
                    await bucket.file(decodedPath).delete();
                    console.log('Deleted image:', decodedPath);
                }
            } catch (error) {
                console.error('Error deleting image:', url, error);
            }
        });

        await Promise.all(deletePromises);
        console.log(`Cleaned up ${imageUrls.length} images for deleted review`);

        return null;
    });