import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String name;
  final String price;
  final String location;
  final String description;
  final String imageUrl;
  final String createdBy;
  final DateTime? createdAt;

  Restaurant({
    required this.name,
    required this.price,
    required this.location,
    required this.description,
    this.imageUrl = '',
    this.createdBy = '',
    this.createdAt,
  });

  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Restaurant(
      name: data['name'] ?? '',
      price: data['price'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
