# 🚨 LỖI: INSTALL_FAILED_INSUFFICIENT_STORAGE

## 📋 TÓM TẮT VẤN ĐỀ:

Emulator Android không đủ dung lượng để cài đặt app Flutter.

## ✅ GIẢI PHÁP NHANH:

### **Bước 1: Mở Android Studio**

1. Mở Android Studio
2. Vào **Tools → Device Manager** (hoặc **AVD Manager**)

### **Bước 2: Tăng Storage (Quan trọng!)**

1. Tìm emulator **"sdk gphone64 x86 64"**
2. Click dropdown menu (⋮) → **Edit**
3. **Show Advanced Settings**
4. **Storage** section:
   - **Internal Storage**: Thay đổi từ **2GB** → **6GB** (hoặc cao hơn)
   - **SD Card**: Có thể để trống hoặc **512MB**
5. Click **Finish**

### **Bước 3: Wipe Data (Bắt buộc!)**

1. Quay lại Device Manager
2. Click dropdown menu của emulator → **Wipe Data**
3. Xác nhận **"OK"** (quan trọng!)

### **Bước 4: Cold Boot (Bắt buộc!)**

1. Dropdown menu → **Cold Boot Now**
2. **Đóng Android Studio** để đảm bảo thay đổi được áp dụng
3. **Mở lại Android Studio** sau 10-15 giây
4. Vào Device Manager → **Play** button để start emulator

### **Bước 5: Chạy lại app**

```bash
cd danhgianhahang
flutter run
```

---

## 🔄 NẾU VẪN LỖI:

### **Tạo Emulator mới:**

1. **Delete** emulator cũ
2. **Create Virtual Device**
3. **Phone** → **Pixel 6**
4. **API 34+** (Android 14)
5. **Advanced Settings**:
   - **Internal Storage: 8GB**
   - **SD Card: 1GB**
6. **Finish** → **Play**

---

## 🎯 KẾT QUẢ MONG ĐỢI:

Sau khi sửa, bạn sẽ thấy:

```
√ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app-debug.apk...     1.2s
Syncing files to device sdk gphone64 x86 64...               2.3s

Flutter run key commands.
r Hot reload. 🔥🔥🔥
...
✅ App chạy thành công!
```

---

## 💡 MẸO:

- **Đừng quên đóng Android Studio** sau khi edit emulator
- **Wipe Data là bắt buộc** để áp dụng storage mới
- **Cold Boot** để reset emulator hoàn toàn
- **Chờ emulator khởi động xong** trước khi chạy app

---

## 📞 HỖ TRỢ:

Nếu vẫn gặp vấn đề:

1. Kiểm tra file `FIX_EMULATOR_STORAGE.md` (đã tạo)
2. Chạy `FIX_STORAGE.bat` để xem hướng dẫn chi tiết
3. Restart Android Studio và thử lại

**Hãy thực hiện các bước trên và chạy lại `flutter run` nhé!** 🚀
