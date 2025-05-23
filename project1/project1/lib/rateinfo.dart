import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/rating_provider.dart';

class RateInfo extends StatefulWidget {
  final String restaurantName;
  final double rating;

  const RateInfo({
    super.key,
    required this.restaurantName,
    required this.rating,
  });

  @override
  State<RateInfo> createState() => _RateInfoState();
}

class _RateInfoState extends State<RateInfo> {
  double _userRating = 0;

  @override
  Widget build(BuildContext context) {
    final ratingProvider = Provider.of<RatingProvider>(context);
    final currentRating = _userRating > 0 ? _userRating : widget.rating; // Changed this line

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 200, // Reduced from 250
                  width: double.infinity,
                  margin: const EdgeInsets.all(20), // Added margin
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), // Added rounded corners
                    image: const DecorationImage(
                      image: AssetImage('assets/ServTech.png'),
                      fit: BoxFit.contain, // Changed from cover to contain
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.restaurantName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff184c6b),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'التقييم الحالي: $currentRating', // Changed to use currentRating
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xff184c6b),
                        ),
                      ),
                      const Icon(
                        Icons.star,
                        color: Color(0xffc29424),
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'اضف تقييمك',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff184c6b),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _userRating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.star,
                            size: 40,
                            color: index < _userRating
                                ? const Color(0xffc29424)
                                : Colors.grey[300],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _userRating > 0
                          ? () {
                              ratingProvider.updateRating(
                                widget.restaurantName,
                                _userRating,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم ارسال تقييمك بنجاح'),
                                  backgroundColor: Color(0xff184c6b),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffc29424),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'إرسال التقييم',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
