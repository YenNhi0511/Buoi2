# Restaurant Review App - Hướng dẫn Setup (ImgBB Storage)

## 🔥 Cài đặt Firebase + ImgBB

### Bước 1: Tạo Firebase Project

1. Truy cập [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** (hoặc "Thêm dự án")
3. Nhập tên project: **`danhgianhahang`**
4. Tắt Google Analytics (không bắt buộc cho demo)
5. Click **"Create project"**

### Bước 2: Thêm Android App

#### 2.1. Đăng ký Android app

1. Trong Firebase Console, click biểu tượng Android
2. **Android package name**: `com.example.danhgianhahang`
   - Lấy từ file `android/app/build.gradle.kts` dòng `namespace`
3. **App nickname**: Restaurant Review (tùy chọn)
4. Click **"Register app"**

#### 2.2. Download config file

1. Tải file **`google-services.json`**
2. Copy vào thư mục: **`android/app/`**

#### 2.3. Cấu hình đã tự động

Các dependency Firebase đã được thêm sẵn trong:

- `android/build.gradle.kts`: classpath Google Services
- `android/app/build.gradle.kts`: plugin google-services
- `pubspec.yaml`: các package Firebase + HTTP client

**Quan trọng:** Đảm bảo file `android/app/build.gradle.kts` có plugin:

```gradle
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")  // ← Phải có dòng này
    id("dev.flutter.flutter-gradle-plugin")
}
```

### Bước 3: Kích hoạt Firebase Services

#### 3.1. Authentication

1. Trong Firebase Console, vào **"Authentication"**
2. Click **"Get started"**
3. Chọn **"Email/Password"**
4. Bật **"Enable"** → Save

#### 3.2. Firestore Database

1. Vào **"Firestore Database"**
2. Click **"Create database"**
3. Chọn **"Start in test mode"** (cho development)
4. Chọn location: **asia-southeast1** (Singapore)
5. Click **"Enable"**

#### 3.3. ~~Firebase Storage~~ → Thay bằng ImgBB (MIỄN PHÍ)

**Không cần Firebase Storage nữa!** Chúng ta dùng ImgBB API miễn phí.

### Bước 4: Đăng ký ImgBB API Key

#### 4.1. Tạo tài khoản ImgBB

1. Truy cập [ImgBB](https://imgbb.com/)
2. Click **"Sign Up"** (đăng ký miễn phí)
3. Xác nhận email

#### 4.2. Lấy API Key

1. Đăng nhập vào tài khoản ImgBB
2. Vào **"API"** tab
3. Copy **API Key** (ví dụ: `abc123def456...`)

#### 4.3. Cập nhật code

1. Mở file: `lib/data/repositories/restaurant_repository_impl.dart`
2. Tìm dòng: `static const String _imgbbApiKey = 'YOUR_IMGBB_API_KEY_HERE';`
3. Thay bằng API key của bạn:
   ```dart
   static const String _imgbbApiKey = 'abc123def456...'; // Thay bằng key thật
   ```

**Lưu ý về ImgBB:**

- **Miễn phí**: 500 ảnh/tháng, 32MB/ảnh
- **Không cần credit card**
- **API đơn giản**: Upload ảnh → trả về URL trực tiếp

#### 4.4. Test ImgBB API (Tùy chọn)

Trước khi chạy app, bạn có thể test ImgBB API:

1. Mở file `test_imgbb.dart`
2. Thay `YOUR_IMGBB_API_KEY_HERE` bằng API key thật
3. Thay `path/to/your/test/image.jpg` bằng đường dẫn ảnh thật
4. Chạy: `dart test_imgbb.dart`

Nếu thấy "Upload thành công!" thì API hoạt động tốt.

### Bước 4: Tạo Sample Data

#### 4.1. Vào Firestore Console

1. Click **"Start collection"**
2. Collection ID: **`restaurants`**

#### 4.2. Thêm restaurant đầu tiên

Click "Add document", nhập:

```
Document ID: (auto-generated)

Fields:
name (string): "Phở Hà Nội"
address (string): "123 Nguyễn Huệ, Q1, TP.HCM"
category (string): "Vietnamese"
description (string): "Phở bò truyền thống Hà Nội, nước dùng thơm ngon"
imageUrl (string): "https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=800"
rating (number): 4.5
reviewCount (number): 12
tags (array): ["Vietnamese", "Phở", "Traditional"]
createdAt (timestamp): (click "Add field" → chọn timestamp → click "Set to current time")
```

#### 4.3. Thêm thêm restaurants

Tạo thêm 2-3 nhà hàng khác với format tương tự:

**Restaurant 2:**

```
name: "Pizza Italia"
address: "456 Lê Lợi, Q1, TP.HCM"
category: "Italian"
description: "Pizza chính gốc Ý, lò nướng gỗ truyền thống"
imageUrl: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800"
rating: 4.8
reviewCount: 25
tags: ["Italian", "Pizza", "Pasta"]
createdAt: (current timestamp)
```

**Restaurant 3:**

```
name: "Sushi Tokyo"
address: "789 Pasteur, Q3, TP.HCM"
category: "Japanese"
description: "Sushi tươi ngon, đầu bếp Nhật Bản chính hiệu"
imageUrl: "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800"
rating: 4.7
reviewCount: 18
tags: ["Japanese", "Sushi", "Seafood"]
createdAt: (current timestamp)
```

### Bước 5: Cấu hình Security Rules

#### 5.1. Firestore Rules

Vào **"Firestore Database" → "Rules"**, thay bằng:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Cho phép đọc restaurants public
    match /restaurants/{restaurantId} {
      allow read: if true;
      allow write: if request.auth != null;

      // Reviews subcollection
      match /reviews/{reviewId} {
        allow read: if true;
        allow create: if request.auth != null;
        allow update, delete: if request.auth != null && request.auth.uid == resource.data.userId;
      }
    }
  }
}
```

#### 5.2. ~~Storage Rules~~ (Không cần nữa - dùng ImgBB)

Click **"Publish"** cho Firestore rules.

#### 5.3. Cloud Functions (Backend Processing)

**Cloud Functions đã được triển khai sẵn!** Ứng dụng sử dụng Cloud Functions để:

- **Tự động tính điểm trung bình**: Khi có review mới, Cloud Function sẽ tự động tính lại average rating của nhà hàng
- **Dọn dẹp ảnh**: Khi xóa review, tự động xóa các ảnh liên quan khỏi Storage

##### 5.3.1. Cài đặt Firebase CLI (nếu chưa có)

```bash
npm install -g firebase-tools
firebase login
```

##### 5.3.2. Khởi tạo Functions trong project

```bash
cd danhgianhahang
firebase init functions
# Chọn project: danhgianhahang
# Chọn language: JavaScript
# Chọn ESLint: Yes
```

##### 5.3.3. Deploy Functions

```bash
# Cài dependencies
cd functions
npm install

# Deploy functions
firebase deploy --only functions
```

##### 5.3.4. Test Functions locally

```bash
# Chạy emulator
firebase emulators:start

# Test bằng cách thêm/xóa review trong app
```

**Quan trọng:** Cloud Functions sẽ chạy tự động trên Firebase servers, không cần code client-side để tính toán.

## ▶️ Chạy App

### 1. Kiểm tra Flutter

```bash
flutter doctor
```

### 2. Get dependencies

```bash
cd danhgianhahang
flutter pub get
```

### 3. Chạy app

```bash
# Kết nối thiết bị/emulator Android
flutter devices

# Run app
flutter run
```

### 4. Test flow

1. **Register**: Tạo tài khoản với email/password
2. **Login**: Đăng nhập
3. **Home**: Xem danh sách nhà hàng
4. **Detail**: Click vào nhà hàng → xem chi tiết
5. **Add Review**: Click "Add Review" → đánh giá + upload ảnh

---

## 🏗️ Kiến trúc Clean Architecture

```
lib/
├── domain/              # Business logic
│   ├── entities/        # Restaurant, Review, User
│   ├── repositories/    # Abstract interfaces
│   └── usecases/        # GetRestaurants, AddReview
├── data/                # Data layer
│   ├── models/          # Firestore models
│   └── repositories/    # Firebase implementations
├── presentation/        # UI layer
│   ├── providers/       # State management
│   └── screens/         # UI screens
└── core/                # Shared code
    └── injection_container.dart  # Dependency injection
```

---

## 🔍 Troubleshooting

### Lỗi: "Failed to initialize Firebase"

- Kiểm tra file `google-services.json` đã copy đúng vào `android/app/`
- Rebuild: `flutter clean && flutter pub get && flutter run`

### Lỗi: "User not logged in"

- Đảm bảo đã đăng ký/đăng nhập
- Kiểm tra Firebase Authentication đã enable Email/Password

### Lỗi build Gradle

- Đảm bảo Android SDK đã cài
- Update Gradle wrapper: `cd android && ./gradlew wrapper --gradle-version 8.0`

### Lỗi: "INSTALL_FAILED_INSUFFICIENT_STORAGE"

Đây là lỗi phổ biến với Android Emulator:

#### Cách 1: Tăng dung lượng Emulator

1. Mở Android Studio → AVD Manager
2. Edit emulator → Show Advanced Settings
3. Tăng **Internal Storage** (tối thiểu 2GB)
4. Restart emulator

#### Cách 2: Wipe Data Emulator

1. Trong AVD Manager, click dropdown menu của emulator
2. Chọn **Wipe Data**
3. Restart emulator

#### Cách 3: Cold Boot

1. Trong AVD Manager, click dropdown menu
2. Chọn **Cold Boot Now**

#### Cách 4: Tạo Emulator mới

1. Trong AVD Manager, click **Create Virtual Device**
2. Chọn device với storage lớn hơn (4GB+)

### Ảnh không upload được

- Kiểm tra API Key ImgBB đã được cập nhật trong `restaurant_repository_impl.dart`
- Kiểm tra kết nối internet
- Kiểm tra permission ảnh trên thiết bị: Settings → Apps → Permissions
- Kiểm tra kích thước ảnh (ImgBB giới hạn 32MB)

---

## 📱 Features Implemented

✅ Firebase Authentication (Email/Password)  
✅ Cloud Firestore (Restaurants + Reviews)  
✅ Firebase Cloud Storage (Image upload)  
✅ Firebase Cloud Messaging (Push notifications)  
✅ Cloud Functions (Auto-calculate ratings)  
✅ ImgBB API (Backup image storage)  
✅ Image Picker (Gallery/Camera)  
✅ Clean Architecture  
✅ State Management (Provider)  
✅ Dependency Injection (GetIt)  
✅ Form Validation  
✅ Rating System  
✅ Real-time Data Updates (StreamBuilder)  
✅ Automatic Image Cleanup

---

## 🚀 Next Steps (Optional)

- [ ] Firebase Cloud Messaging (Push notifications)
- [ ] User profile with avatar
- [ ] Search & filter restaurants
- [ ] Favorite restaurants
- [ ] Edit/Delete reviews
- [ ] Restaurant owner dashboard

---

**Tác giả**: Flutter Developer  
**Dự án**: Buổi 2 - Hệ thống Đánh giá Nhà hàng
