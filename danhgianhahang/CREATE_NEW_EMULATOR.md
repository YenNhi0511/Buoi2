# 🚀 TẠO EMULATOR MỚI VỚI STORAGE LỚN

## ✅ GIẢI PHÁP CUỐI CÙNG:

### **Bước 1: Mở Android Studio**

1. Mở Android Studio
2. Vào **Tools → Device Manager**

### **Bước 2: Xóa Emulator Cũ**

1. Tìm emulator **"sdk gphone64 x86 64"**
2. Click dropdown menu (⋮) → **Delete**
3. Xác nhận **"Delete"**

### **Bước 3: Tạo Emulator Mới**

1. Click **"+ Create device"** (hoặc **"Create Virtual Device"**)

### **Bước 4: Chọn Hardware**

1. **Category**: **Phone**
2. **Device**: **Pixel 6** (hoặc Pixel 7/8)
3. Click **"Next"**

### **Bước 5: Chọn System Image**

1. **API Level**: **API 34** (Android 14) hoặc **API 35** (Android 15)
2. **ABI**: **x86_64** (cho AMD/Intel)
3. Nếu chưa có, click **"Download"** để tải
4. Click **"Next"**

### **Bước 6: Cấu hình Emulator (QUAN TRỌNG!)**

1. **AVD Name**: `Pixel_6_API_34_Storage_Large` (tùy chọn)
2. Click **"Show Advanced Settings"**

### **Bước 7: Cài đặt Storage (CHỦ ĐẠO)**

Trong **Advanced Settings**:

- **Internal Storage**: **8192 MB** (8GB) ← **Quan trọng!**
- **SD Card**: **1024 MB** (1GB) hoặc để trống
- **RAM**: **2048 MB** (2GB) hoặc cao hơn nếu máy mạnh
- **VM Heap**: **256 MB**

### **Bước 8: Hoàn thành**

1. Click **"Finish"**
2. Emulator mới sẽ xuất hiện trong danh sách

### **Bước 9: Khởi động Emulator**

1. Click **Play button** (▶️) bên cạnh emulator mới
2. **Chờ emulator khởi động hoàn toàn** (có thể mất 3-5 phút lần đầu)
3. Đợi đến khi thấy màn hình home của Android

### **Bước 10: Chạy App**

```bash
cd danhgianhahang
flutter run --device-id emulator-XXXX
```

---

## 🎯 KẾT QUẢ MONG ĐỢI:

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

## 💡 MẸO:

- **8GB Internal Storage** là đủ cho hầu hết apps Flutter
- **API 34+** tương thích tốt với Firebase
- **x86_64 ABI** chạy nhanh trên máy tính hiện đại
- **Chờ emulator khởi động xong** trước khi chạy app

---

## 🔧 NẾU VẪN CÓ VẤN ĐỀ:

### **Kiểm tra Device ID:**

```bash
flutter devices
```

Tìm emulator mới và dùng device ID đúng.

### **Force Stop & Restart:**

```bash
adb kill-server
adb start-server
flutter run
```

---

## 📞 HỖ TRỢ:

Nếu vẫn lỗi, có thể do:

1. **RAM máy tính không đủ** - Đóng các app khác
2. **Disk space không đủ** - Dọn dẹp ổ cứng
3. **Virtualization chưa enable** - Kiểm tra BIOS

**Hãy thử tạo emulator mới theo hướng dẫn trên nhé!** 🚀
