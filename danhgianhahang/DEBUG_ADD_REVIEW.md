# 🔧 DEBUG: Khắc phục lỗi "chưa thể thêm bình luận"

## 🚨 **Các nguyên nhân có thể gây lỗi:**

### 1. **Chưa đăng nhập**

- **Dấu hiệu**: Lỗi "Bạn chưa đăng nhập"
- **Khắc phục**: Đăng nhập lại app

### 2. **ImgBB API Key không hợp lệ**

- **Dấu hiệu**: Lỗi network hoặc upload thất bại
- **Khắc phục**:
  1. Truy cập https://imgbb.com/
  2. Đăng ký tài khoản miễn phí
  3. Vào tab "API" → Copy API Key
  4. Mở file `lib/data/repositories/restaurant_repository_impl.dart`
  5. Thay `'YOUR_IMGBB_API_KEY_HERE'` bằng key thật

### 3. **Firebase chưa setup đúng**

- **Dấu hiệu**: Lỗi Firestore permission
- **Khắc phục**: Kiểm tra Firebase Console đã enable Authentication & Firestore

### 4. **Network issues**

- **Dấu hiệu**: Timeout hoặc connection errors
- **Khắc phục**: Kiểm tra kết nối internet

---

## 🧪 **Cách test từng bước:**

### **Bước 1: Test ImgBB API**

```bash
# Chạy test file
dart test_imgbb.dart
```

Nếu thấy lỗi, hãy làm theo hướng dẫn trong file để lấy API key thật.

### **Bước 2: Test Firebase**

1. Mở app
2. Thử đăng ký/đăng nhập
3. Nếu OK → Tiếp tục
4. Nếu lỗi → Kiểm tra Firebase Console

### **Bước 3: Test Add Review**

1. Đăng nhập vào app
2. Vào chi tiết nhà hàng
3. Click "Add Review"
4. Thêm đánh giá (có thể không có ảnh)
5. Submit và xem lỗi cụ thể

---

## 📱 **Lỗi thường gặp & Khắc phục:**

### **"Bạn chưa đăng nhập"**

- Đăng xuất và đăng nhập lại
- Restart app

### **"Failed to upload image"**

- Kiểm tra API key ImgBB
- Kiểm tra kết nối internet
- Thử submit review không có ảnh

### **"Permission denied" (Firestore)**

- Kiểm tra Firestore rules trong Firebase Console
- Đảm bảo user đã đăng nhập

### **"Network error"**

- Kiểm tra kết nối internet
- Thử lại sau vài phút

---

## 🔍 **Debug nâng cao:**

### **Xem logs chi tiết:**

```bash
flutter run --verbose
```

### **Test Firestore trực tiếp:**

1. Mở Firebase Console → Firestore
2. Thử thêm document manually
3. Kiểm tra rules có hoạt động

### **Test API key:**

```dart
// Trong test_imgbb.dart, thay API key và chạy
const apiKey = 'your_real_api_key_here';
```

---

## ✅ **Nếu vẫn lỗi:**

1. **Restart app**: `flutter clean && flutter run`
2. **Restart emulator**: Tắt emulator, khởi động lại
3. **Check dependencies**: `flutter pub get`
4. **Update Flutter**: `flutter upgrade`

---

## 📞 **Cần hỗ trợ?**

Nếu vẫn gặp lỗi, hãy:

1. Chạy `flutter run --verbose`
2. Copy error message đầy đủ
3. Mô tả các bước đã làm

**Lỗi thường do API key ImgBB hoặc Firebase setup!** 🔑
