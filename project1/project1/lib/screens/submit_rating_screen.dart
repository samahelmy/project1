import 'package:flutter/material.dart';
import '../services/rating_service.dart';

class SubmitRatingScreen extends StatefulWidget {
  final String restaurantName;

  const SubmitRatingScreen({super.key, required this.restaurantName});

  @override
  State<SubmitRatingScreen> createState() => _SubmitRatingScreenState();
}

class _SubmitRatingScreenState extends State<SubmitRatingScreen> {
  double _rating = 0;
  bool _isSubmitting = false;
  final _ratingService = RatingService();
  final _commentController = TextEditingController(); // Add this line

  Future<void> _submitRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار تقييم')));
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إضافة تعليق')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await _ratingService.submitRating(restaurantName: widget.restaurantName, rating: _rating, comment: _commentController.text.trim());

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ في حفظ التقييم')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose(); // Add this line
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff184c6b),
          title: const Text('إضافة تقييم'),
          leading: IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: () => Navigator.pop(context)),
        ),
        body: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.restaurantName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff184c6b)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(index < _rating ? Icons.star : Icons.star_border, size: 40, color: const Color(0xffc29424)),
                      onPressed: () {
                        setState(() => _rating = index + 1.0);
                      },
                    );
                  }),
                ),
                const SizedBox(height: 32),
                // Add comment TextField
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'اكتب تعليقك هنا...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRating,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff184c6b), padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('حفظ التقييم'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
