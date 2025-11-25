import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  // ImgBB API Key
  static const String _imgbbApiKey = '3c80e8c592b06e6f5f49d996b8689d20';
  static const String _imgbbApiUrl = 'https://api.imgbb.com/1/upload';

  /// Chọn ảnh từ gallery hoặc camera
  Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Không thể chọn ảnh: $e');
    }
  }

  /// Chọn nhiều ảnh từ gallery
  Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return pickedFiles.map((file) => File(file.path)).toList();
    } catch (e) {
      throw Exception('Không thể chọn ảnh: $e');
    }
  }

  /// Upload ảnh lên Firebase Storage
  Future<String> uploadToFirebaseStorage(File imageFile, String folder) async {
    try {
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final Reference storageRef = _firebaseStorage.ref().child(
        '$folder/$fileName',
      );

      final UploadTask uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType:
              'image/${path.extension(imageFile.path).replaceAll('.', '')}',
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Không thể upload ảnh lên Firebase: $e');
    }
  }

  /// Upload ảnh lên ImgBB (backup option)
  Future<String> uploadToImgBB(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(_imgbbApiUrl),
        body: {'key': _imgbbApiKey, 'image': base64Image},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['data']['url'];
      } else {
        throw Exception('ImgBB upload failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể upload ảnh lên ImgBB: $e');
    }
  }

  /// Upload nhiều ảnh và trả về list URLs
  Future<List<String>> uploadMultipleImages(
    List<File> images,
    String folder,
  ) async {
    final List<String> uploadedUrls = [];

    for (final image in images) {
      try {
        // Thử upload lên Firebase Storage trước
        final url = await uploadToFirebaseStorage(image, folder);
        uploadedUrls.add(url);
      } catch (e) {
        // Nếu Firebase thất bại, thử ImgBB
        try {
          final url = await uploadToImgBB(image);
          uploadedUrls.add(url);
        } catch (imgbbError) {
          // Nếu cả hai đều thất bại, bỏ qua ảnh này
          print('Không thể upload ảnh: $imgbbError');
        }
      }
    }

    return uploadedUrls;
  }

  /// Xóa ảnh từ Firebase Storage
  Future<void> deleteFromFirebaseStorage(String imageUrl) async {
    try {
      final Reference storageRef = _firebaseStorage.refFromURL(imageUrl);
      await storageRef.delete();
    } catch (e) {
      throw Exception('Không thể xóa ảnh: $e');
    }
  }
}
