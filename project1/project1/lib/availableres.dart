import 'package:flutter/material.dart';
import 'models/restaurant.dart';

class AvailableRes extends StatelessWidget {
  final Restaurant restaurant;

  const AvailableRes({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Column(
        children: [
          // Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: const Color(0xff184c6b),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Restaurant Image
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/ServTech.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Restaurant Name
                        Text(
                          restaurant.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff184c6b),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              restaurant.location,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Description Title
                        const Text(
                          "الوصف",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff184c6b),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Description Text
                        const Text(
                          "تباع وجهاً في الڤلل المعاصرة في الخالصي في الموقع، والدابر دخل مدوري مجددومخصات. خفار ضار.",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Price Title
                        const Text(
                          "السعر",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff184c6b),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Price
                        Text(
                          "البيع ${restaurant.price} ر.س",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xffc29424),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Contact Button - Moved here
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle contact action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffc29424),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "اتصل",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
