import 'package:flutter/material.dart';
import '../widgets/smart_image.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6F2),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Restaurant Image
              Stack(
                children: [
                  SmartImage(imageUrl: restaurant['imageUrl'], height: 250),
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
                    Text(restaurant['name'] ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                    const SizedBox(height: 8),
                    Text(restaurant['address'] ?? '', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xffc29424), size: 28),
                        const SizedBox(width: 8),
                        Text(
                          (restaurant['rating'] ?? 0.0).toStringAsFixed(1),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff184c6b)),
                        ),
                      ],
                    ),
                    if (restaurant['description'] != null) ...[
                      const SizedBox(height: 16),
                      Text(restaurant['description'], style: const TextStyle(fontSize: 16, color: Colors.black87)),
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
                          Expanded(child: Text(restaurant['address'] ?? '', style: const TextStyle(fontSize: 16, color: Colors.black87))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
