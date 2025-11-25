// Test file để kiểm tra ImgBB API
// Chạy file này để test upload ảnh trước khi chạy app

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  // 📝 HƯỚNG DẪN LẤY API KEY:
  // 1. Truy cập https://imgbb.com/
  // 2. Đăng ký tài khoản miễn phí
  // 3. Xác nhận email
  // 4. Vào tab "API" để lấy API Key
  // 5. Thay YOUR_IMGBB_API_KEY_HERE bằng key thật

  const apiKey = '3c80e8c592b06e6f5f49d996b8689d20';

  // Đường dẫn tới ảnh test (thay bằng ảnh thật trên máy bạn)
  const imagePath = r'C:\path\to\your\test\image.jpg';

  if (apiKey == 'YOUR_IMGBB_API_KEY_HERE') {
    print(
      '❌ Vui lòng thay YOUR_IMGBB_API_KEY_HERE bằng API key thật từ https://imgbb.com/',
    );
    print('📝 Hướng dẫn:');
    print('   1. Truy cập https://imgbb.com/');
    print('   2. Đăng ký tài khoản miễn phí');
    print('   3. Vào tab "API" để lấy API Key');
    return;
  }

  try {
    final file = File(imagePath);
    if (!await file.exists()) {
      print('❌ File không tồn tại: $imagePath');
      print('💡 Hãy thay imagePath bằng đường dẫn tới ảnh thật trên máy bạn');
      return;
    }

    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    print('📤 Đang upload ảnh...');

    final response = await http.post(
      Uri.parse('https://api.imgbb.com/1/upload'),
      body: {'key': apiKey, 'image': base64Image},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        final imageUrl = jsonResponse['data']['url'];
        print('✅ Upload thành công!');
        print('🔗 URL: $imageUrl');
        print('📱 Bây giờ bạn có thể chạy app và test thêm review!');
      } else {
        print('❌ Upload thất bại: ${jsonResponse['error']}');
        print('💡 Kiểm tra API key có đúng không');
      }
    } else {
      print('❌ HTTP Error: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('❌ Lỗi: $e');
  }
}
