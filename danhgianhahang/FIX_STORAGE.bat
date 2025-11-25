@echo off
echo ================================================
echo    HƯỚNG DẪN SỬA EMULATOR STORAGE
echo ================================================
echo.
echo BƯỚC 1: MỞ ANDROID STUDIO
echo --------------------------
echo 1. Mở Android Studio
echo 2. Vào Tools → Device Manager (hoặc AVD Manager)
echo 3. Tìm emulator "sdk gphone64 x86 64"
echo.
echo BƯỚC 2: EDIT EMULATOR STORAGE
echo -----------------------------
echo 1. Click dropdown menu (3 chấm) bên cạnh emulator
echo 2. Chọn "Edit" (hoặc "Edit this AVD")
echo 3. Trong cửa sổ Virtual Device Configuration:
echo    - Click "Show Advanced Settings"
echo    - Tìm phần "Storage"
echo    - Thay đổi "Internal Storage" từ 2GB → 4GB
echo    - Click "Finish"
echo.
echo BƯỚC 3: WIPE DATA
echo ------------------
echo 1. Quay lại Device Manager
echo 2. Click dropdown menu của emulator
echo 3. Chọn "Wipe Data"
echo 4. Xác nhận "OK"
echo.
echo BƯỚC 4: COLD BOOT
echo ------------------
echo 1. Click dropdown menu của emulator
echo 2. Chọn "Cold Boot Now"
echo 3. Chờ emulator khởi động lại (có thể mất 1-2 phút)
echo.
echo BƯỚC 5: CHẠY APP
echo -----------------
echo Sau khi emulator đã khởi động xong, chạy:
echo cd danhgianhahang
echo flutter run
echo.
echo ================================================
echo    THÔNG TIN THÊM
echo ================================================
echo.
echo Nếu vẫn lỗi, tạo emulator mới:
echo 1. Xóa emulator cũ (dropdown → Delete)
echo 2. Create Virtual Device
echo 3. Chọn Phone → Pixel 6
echo 4. Chọn API 34+ (Android 14)
echo 5. Advanced Settings → Internal Storage: 4GB
echo.
pause