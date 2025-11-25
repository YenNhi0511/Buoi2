# 🚨 **KHẮC PHỤC LỖI: INSTALL_FAILED_INSUFFICIENT_STORAGE**

## ⚠️ **VẤN ĐỀ HIỆN TẠI:**

Emulator "RestaurantApp" và "Pixel7" không đủ dung lượng internal storage để cài đặt APK Flutter.

## ✅ **GIẢI PHÁP NGAY LẬP TỨC:**

### **Bước 1: Mở Android Studio**

- Khởi động Android Studio trên máy tính của bạn

### **Bước 2: Mở Device Manager**

- Click **Tools** → **Device Manager** (hoặc **AVD Manager**)
- Hoặc nhấn **Shift + Shift** → gõ "Device Manager"

### **Bước 3: Tìm và Edit Emulator "Pixel7" hoặc "RestaurantApp"**

- Tìm emulator có tên **"Pixel7"** (hoặc **"RestaurantApp"** nếu muốn dùng cái kia)
- Click vào **⋮ (3 chấm)** bên phải
- Chọn **"Edit"** (hoặc **"Edit this AVD"**)

### **Bước 4: Tăng Internal Storage (QUAN TRỌNG!)**

Trong cửa sổ **"Virtual Device Configuration"**:

1. **Click "Show Advanced Settings"** (ở cuối cửa sổ)
2. **Tìm phần "Memory and Storage"**
3. **Thay đổi "Internal Storage"**:
   - **Hiện tại:** Có thể là 512MB, 2GB, hoặc 4GB
   - **Thay thành:** **8192 MB** (8GB) ← **Bắt buộc!**
4. **RAM**: Có thể tăng lên **2048 MB** nếu máy mạnh
5. **Click "Finish"** để lưu thay đổi

### **Bước 5: Wipe Data Emulator**

1. Quay lại **Device Manager**
2. Click **⋮** của emulator **"Pixel7"** (hoặc **"RestaurantApp"**)
3. Chọn **"Wipe Data"**
4. Xác nhận **"Wipe user data"**

### **Bước 6: Cold Boot**

1. Click **⋮** → **"Cold Boot Now"**
2. Chờ emulator khởi động lại hoàn toàn (3-5 phút)

### **Bước 7: Chạy lại app**

```bash
cd d:\TH_Flutter\Buoi2\danhgianhahang
flutter run
```

---

## 🔍 **KIỂM TRA ĐÃ ĐÚNG CHƯA:**

### **Xem storage trong emulator:**

1. Mở emulator
2. Vào **Settings** → **Storage** → **Internal shared storage**
3. Phải có ít nhất **2GB trống**

---

## 📱 **KẾT QUẢ MONG ĐỢI:**

```
√ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app-debug.apk...     1.5s
Syncing files to device sdk gphone64 x86 64...               3.2s

Flutter run key commands.
r Hot reload. 🔥🔥🔥
p Toggle screenshot mode.
s Stop and hot restart.
...
✅ Restaurant Review App chạy thành công!
```

---

## 💡 **LÝ DO CẦN 8GB:**

- **APK Flutter** thường 50-100MB
- **App data + cache** cần thêm dung lượng
- **System updates** cần space
- **8GB** đảm bảo đủ cho development

---

## 🔄 **NẾU VẪN LỖI:**

### **Tạo emulator hoàn toàn mới:**

```bash
flutter emulators --create --name RestaurantApp8GB
```

Sau đó lặp lại bước 4 với 8GB storage.

### **Hoặc dùng command line:**

```bash
# Tăng storage qua command line (nếu biết AVD path)
# Thường ở: C:\Users\[User]\.android\avd\RestaurantApp.avd
```

---

## ⚡ **QUICK FIX:**

Nếu Android Studio không mở được:

1. **Restart máy tính**
2. **Update Android Studio** lên phiên bản mới nhất
3. **Check disk space** (cần 10GB+ trống trên ổ C)

---

## 📞 **CẦN HỖ TRỢ:**

Nếu làm theo hướng dẫn mà vẫn lỗi:

1. **Screenshot** cửa sổ Edit emulator
2. **Gửi error message** cụ thể
3. **Thông tin máy tính** (RAM, disk space)

**Hãy làm theo hướng dẫn và thử lại nhé!** 🚀

#### Bước 1: Xóa emulator cũ

1. Device Manager → dropdown menu → **Delete**
2. Xác nhận xóa

#### Bước 2: Tạo emulator mới

1. Click **Create device**
2. Chọn **Phone** → **Pixel 6** (hoặc bất kỳ)
3. Click **Next**
4. Chọn **API 34** (Android 14) hoặc cao hơn
5. Trong **Advanced Settings**:
   - **Internal Storage**: **4GB**
   - **SD Card**: **512MB** (tùy chọn)
6. Click **Finish**

#### Bước 3: Khởi động emulator mới

1. Click **Play** button để start emulator
2. Chờ emulator khởi động hoàn toàn

#### Bước 4: Chạy app

```bash
flutter run
```

---

## 💡 Mẹo:

- **Kiểm tra storage**: Trong emulator, vào Settings → Storage để xem dung lượng còn lại
- **Uninstall apps cũ**: Nếu có apps cũ, uninstall để giải phóng dung lượng
- **Restart ADB**: `adb kill-server && adb start-server`

---

## 🎯 Test thành công:

Sau khi sửa storage, bạn sẽ thấy:

```
√ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app-debug.apk...     1.2s
Syncing files to device sdk gphone64 x86 64...               2.3s

Flutter run key commands.
r Hot reload. 🔥🔥🔥
p Toggle screenshot mode.
s Stop and hot restart.
...
```

**App sẽ chạy thành công!** 🎉
