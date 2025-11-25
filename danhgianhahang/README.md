# 🍽️ **Restaurant Review System**

Một ứng dụng Flutter hoàn chỉnh cho hệ thống đánh giá nhà hàng với Firebase backend.

## 🔥 **Tính năng chính**

### **Xác thực & Bảo mật**

- ✅ Firebase Authentication (Email/Password)
- ✅ Đăng ký, đăng nhập, đăng xuất an toàn
- ✅ Quản lý session người dùng

### **Dữ liệu thời gian thực**

- ✅ Cloud Firestore database
- ✅ Real-time updates cho reviews
- ✅ Automatic rating calculation

### **Upload ảnh miễn phí**

- ✅ Image Picker (Camera/Gallery)
- ✅ ImgBB API (MIỄN PHÍ - không tốn phí Firebase Storage)
- ✅ Multiple images per review
- ✅ Base64 encoding & HTTP upload

### **UI/UX hiện đại**

- ✅ Material Design 3
- ✅ Sliver widgets với hiệu ứng cuộn mượt
- ✅ Hero animations
- ✅ Gradient backgrounds
- ✅ Loading states & error handling

### **Thông báo**

- ✅ Firebase Cloud Messaging (FCM)
- ✅ Local notifications
- ✅ Background message handling

### **Kiến trúc Clean**

- ✅ Domain-Driven Design
- ✅ Dependency Injection (GetIt)
- ✅ State Management (Provider)
- ✅ Repository pattern

---

## 🏗️ **Kiến trúc dự án**

```
lib/
├── domain/              # Business Logic Layer
│   ├── entities/        # Core entities (Restaurant, Review, User)
│   ├── repositories/    # Abstract interfaces
│   └── usecases/        # Business logic (GetRestaurants, AddReview)
├── data/                # Data Layer
│   ├── models/          # Firestore data models
│   └── repositories/    # Firebase implementations
├── presentation/        # Presentation Layer
│   ├── providers/       # State management
│   └── screens/         # UI screens
└── core/                # Shared utilities
    ├── injection_container.dart    # Dependency injection
    └── notification_service.dart   # FCM notifications
```

---

## 🚀 **Cài đặt & Chạy**

### **1. Clone & Setup**

```bash
git clone <repository-url>
cd danhgianhahang
flutter pub get
```

### **2. Firebase Setup**

Xem hướng dẫn chi tiết trong [`FIREBASE_SETUP.md`](./FIREBASE_SETUP.md)

### **3. ImgBB API (Tùy chọn)**

- Đăng ký tài khoản miễn phí tại [ImgBB](https://imgbb.com/)
- Lấy API Key và cập nhật trong `restaurant_repository_impl.dart`

### **4. Chạy ứng dụng**

```bash
flutter run
```

---

## 📱 **Screenshots & Demo**

### **Screens:**

1. **Login/Register** - Firebase Auth
2. **Home** - Danh sách nhà hàng (Sliver UI)
3. **Restaurant Detail** - Chi tiết + reviews
4. **Add Review** - Upload ảnh + đánh giá

### **Features Demo:**

- Real-time review updates
- Image upload với progress
- Push notifications
- Smooth scrolling animations

---

## 🛠️ **Công nghệ sử dụng**

### **Frontend:**

- **Flutter** 3.9.2+ - UI Framework
- **Dart** 3.0+ - Programming language
- **Provider** 6.1.2 - State management
- **GetIt** 8.0.2 - Dependency injection

### **Backend & Services:**

- **Firebase Core** 3.6.0 - App initialization
- **Firebase Auth** 5.3.1 - Authentication
- **Cloud Firestore** 5.4.4 - NoSQL database
- **Firebase Messaging** 15.1.3 - Push notifications
- **ImgBB API** - Free image hosting

### **Media & Utils:**

- **Image Picker** 1.1.2 - Camera/gallery access
- **Cached Network Image** 3.4.1 - Image caching
- **HTTP** 1.2.2 - API calls
- **Flutter Local Notifications** 17.2.2 - Local notifications

---

## 📋 **Yêu cầu hệ thống**

- **Flutter SDK:** 3.9.2+
- **Dart SDK:** 3.0+
- **Android:** API 21+ (Android 5.0+)
- **iOS:** 11.0+
- **Firebase Project** configured
- **Internet connection** cho Firebase & ImgBB

---

## 🔧 **Scripts & Commands**

```bash
# Development
flutter pub get              # Install dependencies
flutter analyze             # Code analysis
flutter test                # Run tests

# Build
flutter build apk           # Build Android APK
flutter build ios           # Build iOS app

# Firebase
flutterfire configure       # Configure Firebase (if using FlutterFire CLI)

# Clean
flutter clean               # Clean build files
flutter pub cache repair    # Fix pub cache issues
```

---

## 📚 **Tài liệu & Hướng dẫn**

- [`FIREBASE_SETUP.md`](./FIREBASE_SETUP.md) - Hướng dẫn setup Firebase
- [`PROJECT_COMPLETION_CHECK.md`](./PROJECT_COMPLETION_CHECK.md) - Kiểm tra tính năng
- [`CREATE_NEW_EMULATOR.md`](./CREATE_NEW_EMULATOR.md) - Tạo emulator mới

---

## 🎯 **Tính năng đã hoàn thành**

✅ **Firebase Authentication** - Đăng ký/đăng nhập  
✅ **Cloud Firestore** - Database thời gian thực  
✅ **Image Upload** - ImgBB API (MIỄN PHÍ)  
✅ **Push Notifications** - FCM + Local notifications  
✅ **Clean Architecture** - Domain/Data/Presentation layers  
✅ **Sliver Widgets** - UI cuộn mượt với animations  
✅ **State Management** - Provider + GetIt DI  
✅ **Material Design 3** - UI hiện đại  
✅ **Error Handling** - Comprehensive error management  
✅ **Image Caching** - CachedNetworkImage  
✅ **Form Validation** - Input validation

---

## 🚀 **Next Steps (Optional)**

- [ ] Firebase Cloud Functions cho server-side notifications
- [ ] User profiles với avatars
- [ ] Search & filter restaurants
- [ ] Favorite restaurants
- [ ] Edit/Delete reviews
- [ ] Restaurant owner dashboard
- [ ] Google Maps integration
- [ ] Social login (Google, Facebook)

---

## 📞 **Liên hệ & Support**

**Tác giả:** Flutter Developer  
**Dự án:** Restaurant Review System  
**Version:** 1.0.0

Nếu có vấn đề, hãy tạo issue hoặc liên hệ developer.

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**🎉 Happy coding!**
