# Restaurant Review App - Firebase Setup Guide

## Firebase Configuration Required

Before running the app, you need to configure Firebase for your project.

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one
3. Enable the following services:
   - Authentication (Email/Password)
   - Cloud Firestore
   - Firebase Storage
   - Firebase Cloud Messaging
   - Cloud Functions

### Step 2: Generate Firebase Configuration

1. In Firebase Console, go to Project Settings
2. Scroll down to "Your apps" section
3. Add Flutter app and follow the instructions
4. Download the `google-services.json` file for Android
5. Download the `GoogleService-Info.plist` file for iOS

### Step 3: Update firebase_options.dart

Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase configuration:

```dart
// For Android
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-actual-android-api-key',
  appId: 'your-actual-android-app-id',
  messagingSenderId: 'your-actual-messaging-sender-id',
  projectId: 'your-actual-project-id',
  storageBucket: 'your-actual-project-id.appspot.com',
);

// For iOS
static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'your-actual-ios-api-key',
  appId: 'your-actual-ios-app-id',
  messagingSenderId: 'your-actual-messaging-sender-id',
  projectId: 'your-actual-project-id',
  storageBucket: 'your-actual-project-id.appspot.com',
);
```

### Step 4: Firestore Security Rules

Add these security rules in Firebase Console > Firestore > Rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Restaurants are publicly readable
    match /restaurants/{restaurantId} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    // Reviews can be read by anyone, written by authenticated users
    match /reviews/{reviewId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### Step 5: Storage Security Rules

Add these security rules in Firebase Console > Storage > Rules:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Images are publicly readable
    match /images/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### Step 6: Cloud Functions (Optional)

If you want to use automatic rating calculations, deploy these Cloud Functions:

1. Create a `functions` folder in your project root
2. Initialize Cloud Functions: `firebase init functions`
3. Add the rating calculation function in `functions/index.js`

## Running the App

After Firebase configuration:

1. Install dependencies: `flutter pub get`
2. Run the app: `flutter run`

## Features Implemented

- ✅ Firebase Authentication (Email/Password)
- ✅ Clean Architecture pattern
- ✅ Provider state management
- ✅ Dependency injection with GetIt
- ✅ Core entities (User, Restaurant, Review)
- ✅ Auth domain layer (repository, use cases)
- ✅ Auth data layer (Firebase implementation)
- ✅ Auth presentation layer (Provider)
- 🔄 Restaurant features (in progress)
- 🔄 Review features (in progress)
- 🔄 Image upload with Firebase Storage
- 🔄 Push notifications with FCM
- 🔄 Cloud Functions for rating calculations

## Next Steps

1. Complete restaurant listing and details
2. Implement review creation with image upload
3. Add Firebase Cloud Messaging for notifications
4. Deploy Cloud Functions for automatic rating updates
5. Add offline support with SQLite
6. Implement search and filtering
