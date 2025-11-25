import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/restaurant.dart';
import '../../../core/entities/review.dart';
import '../../../features/review/domain/usecases/add_review.dart';
import '../../../domain/repositories/restaurant_repository.dart';
import '../../../core/injection_container.dart';
import '../../providers/auth_provider.dart';

class AddReviewScreen extends StatefulWidget {
  final Restaurant restaurant;

  const AddReviewScreen({super.key, required this.restaurant});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  final List<File> _images = [];
  double _rating = 5.0;
  bool _loading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final user = context.read<AuthProvider>().currentUser;
      if (user == null) {
        throw Exception(
          'Bạn chưa đăng nhập. Vui lòng đăng nhập trước khi thêm đánh giá.',
        );
      }

      if (_commentController.text.trim().isEmpty) {
        throw Exception('Vui lòng nhập nội dung đánh giá.');
      }

      // Upload images first (optional)
      final List<String> imageUrls = [];
      if (_images.isNotEmpty) {
        try {
          for (final imageFile in _images) {
            final url = await sl<RestaurantRepository>().uploadReviewImage(
              imageFile.path,
            );
            imageUrls.add(url);
          }
        } catch (imageError) {
          // Show warning but don't fail the review
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Cảnh báo: Không thể upload ảnh - ${imageError.toString()}',
                ),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          // Continue without images
        }
      }

      final review = Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        restaurantId: widget.restaurant.id,
        userId: user.id,
        userName: user.displayName,
        userPhotoUrl: user.photoUrl,
        rating: _rating,
        comment: _commentController.text.trim(),
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final addReview = sl<AddReview>();
      await addReview.call(review, widget.restaurant.name);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đánh giá đã được thêm thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        String errorMessage = 'Lỗi không xác định';
        if (e.toString().contains('userId')) {
          errorMessage = 'Lỗi xác thực người dùng. Vui lòng đăng nhập lại.';
        } else if (e.toString().contains('database')) {
          errorMessage = 'Lỗi cơ sở dữ liệu. Vui lòng thử lại.';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Lỗi kết nối mạng. Kiểm tra internet.';
        } else {
          errorMessage = e.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $errorMessage'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Review'),
        actions: [
          if (_loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          else
            TextButton(
              onPressed: _submitReview,
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              widget.restaurant.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Rating
            const Text(
              'Your Rating',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  iconSize: 40,
                  icon: Icon(
                    index < _rating.toInt() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () =>
                      setState(() => _rating = (index + 1).toDouble()),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Comment
            const Text(
              'Your Review',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please write a review' : null,
            ),
            const SizedBox(height: 24),

            // Images
            const Text(
              'Photos (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_images.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _images[index],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 12,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 16,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  setState(() => _images.removeAt(index)),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Add Photos'),
            ),
          ],
        ),
      ),
    );
  }
}
