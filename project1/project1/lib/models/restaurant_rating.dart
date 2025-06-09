import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantRating {
  final String restaurantName;
  final double rating;
  final String address;
  final String? imageUrl;
  final DateTime createdAt;
  final String createdBy;

  RestaurantRating({
    required this.restaurantName,
    required this.rating,
    required this.address,
    this.imageUrl,
    required this.createdAt,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'restaurantName': restaurantName,
      'rating': rating,
      'address': address,
      'imageUrl': imageUrl ?? 'assets/ServTech.png',
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }

  factory RestaurantRating.fromMap(Map<String, dynamic> map) {
    return RestaurantRating(
      restaurantName: map['restaurantName'] ?? '',
      rating: (map['rating'] as num).toDouble(),
      address: map['address'] ?? '',
      imageUrl: map['imageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] ?? '',
    );
  }
}
