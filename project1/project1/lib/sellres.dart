import 'package:flutter/material.dart';

class SellRes extends StatelessWidget {
  const SellRes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Title
                const Center(
                  child: Text(
                    'اضافة مطعم',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff184c6b),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Form fields wrapped in Expanded
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Restaurant name field
                      buildFormField('اسم المطعم'),
                      // Price field
                      buildFormField('السعر'),
                      // Location field
                      buildFormField('الموقع'),
                      // Description field (larger)
                      buildFormField('الوصف', maxLines: 5),
                    ],
                  ),
                ),
                // Bottom section
                Column(
                  children: [
                    // Add button
                    Center(
                      child: InkWell(
                        onTap: () {
                          // Add your click handling here
                        },
                        child: Container(
                          width: double.infinity, // Changed to take full width
                          padding: const EdgeInsets.symmetric(vertical: 12), // Reduced from 15
                          decoration: BoxDecoration(
                            color: const Color(0xffc29424),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              'اضافة',
                              style: TextStyle(
                                fontSize: 20, // Reduced from 25
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // ServTech text
                    const Text(
                      'ServTech',
                      style: TextStyle(
                        fontSize: 50, // Reduced from 50
                        fontWeight: FontWeight.bold,
                        color: Color(0xff184c6b),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff184c6b),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFormField(String label, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff184c6b),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          style: const TextStyle(color: Colors.black), // Changed to black text
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200], // Changed to match login page
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
      ],
    );
  }
}
