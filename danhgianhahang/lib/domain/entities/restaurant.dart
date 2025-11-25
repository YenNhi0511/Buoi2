import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String address;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String category;
  final List<String> tags;
  final DateTime createdAt;

  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.tags,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    description,
    imageUrl,
    rating,
    reviewCount,
    category,
    tags,
    createdAt,
  ];
}
