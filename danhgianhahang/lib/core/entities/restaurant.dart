import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String? imageUrl;
  final List<String> categories;
  final double latitude;
  final double longitude;
  final double averageRating;
  final int totalReviews;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String ownerId;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    this.imageUrl,
    required this.categories,
    required this.latitude,
    required this.longitude,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.ownerId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    address,
    phone,
    imageUrl,
    categories,
    latitude,
    longitude,
    averageRating,
    totalReviews,
    createdAt,
    updatedAt,
    ownerId,
  ];

  Restaurant copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? phone,
    String? imageUrl,
    List<String>? categories,
    double? latitude,
    double? longitude,
    double? averageRating,
    int? totalReviews,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerId,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'imageUrl': imageUrl,
      'categories': categories,
      'latitude': latitude,
      'longitude': longitude,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'ownerId': ownerId,
    };
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      imageUrl: json['imageUrl'] as String?,
      categories: List<String>.from(json['categories'] as List),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      ownerId: json['ownerId'] as String,
    );
  }
}
