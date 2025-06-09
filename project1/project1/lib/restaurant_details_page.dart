import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/smart_image.dart';

class RestaurantDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot restaurant;

  const RestaurantDetailsPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final data = restaurant.data() as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Restaurant Image
            Stack(
              children: [
                SmartImage(imageUrl: data['imageUrl'], height: 250),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['name'] ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xffc29424), size: 28),
                      const SizedBox(width: 8),
                      Text(
                        (data['rating'] ?? 0.0).toStringAsFixed(1),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff184c6b)),
                      ),
                    ],
                  ),
                  if (data['description'] != null) ...[
                    const SizedBox(height: 16),
                    Text(data['description'], style: const TextStyle(fontSize: 16, color: Colors.black87)),
                  ],
                  const SizedBox(height: 24),
                  // Location Section
                  const Text('الموقع', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xffc29424), size: 24),
                        const SizedBox(width: 12),
                        Expanded(child: Text(data['address'] ?? 'العنوان غير متوفر', style: const TextStyle(fontSize: 16, color: Colors.black87))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
