import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/restaurant_rating.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({super.key});

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  double _rating = 0;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _rating == 0) {
      if (_rating == 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار تقييم')));
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString('phone');

      if (phone == null) throw Exception('User not logged in');

      final rating = RestaurantRating(
        restaurantName: _nameController.text.trim(),
        rating: _rating,
        address: _addressController.text.trim(),
        createdAt: DateTime.now(),
        createdBy: phone,
      );

      await FirebaseFirestore.instance.collection('restaurant_ratings').add(rating.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إضافة المطعم بنجاح')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ في إضافة المطعم')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff184c6b),
          title: const Text('إضافة مطعم جديد', style: TextStyle(color: Colors.white)),
          leading: IconButton(icon: const Icon(Icons.arrow_forward_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم المطعم', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال اسم المطعم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'العنوان', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال عنوان المطعم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text('التقييم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(index < _rating ? Icons.star : Icons.star_border, color: const Color(0xffc29424), size: 32),
                    onPressed: () => setState(() => _rating = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff184c6b), padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('إضافة المطعم'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
