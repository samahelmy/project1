import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddRestaurantForm extends StatefulWidget {
  const AddRestaurantForm({super.key});

  @override
  State<AddRestaurantForm> createState() => _AddRestaurantFormState();
}

class _AddRestaurantFormState extends State<AddRestaurantForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final createdBy = prefs.getString('phone');

      await FirebaseFirestore.instance.collection('restaurants').add({
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'description': _descriptionController.text.trim(),
        'imageUrl': 'assets/ServTech.png', // Placeholder image
        'rating': 0.0, // Initial rating
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Fluttertoast.showToast(msg: 'تم إضافة المطعم بنجاح', backgroundColor: Colors.green);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(msg: 'حدث خطأ في إضافة المطعم', backgroundColor: Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6F2),
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
                decoration: InputDecoration(
                  labelText: 'اسم المطعم',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
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
                decoration: InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال عنوان المطعم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'الوصف',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff184c6b),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child:
                    _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('إضافة المطعم', style: TextStyle(fontSize: 16, color: Colors.white)),
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
    _descriptionController.dispose();
    super.dispose();
  }
}
