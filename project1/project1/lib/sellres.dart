import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellRes extends StatefulWidget {
  const SellRes({super.key});

  @override
  State<SellRes> createState() => _SellResState();
}

class _SellResState extends State<SellRes> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitRestaurant() async {
    // Validate all fields
    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _locationController.text.isEmpty || _descriptionController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'جميع الحقول مطلوبة', backgroundColor: Colors.red, textColor: Colors.white);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Get user phone from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userPhone = prefs.getString('phone');

      if (userPhone == null || userPhone.isEmpty) {
        Fluttertoast.showToast(msg: 'الرجاء تسجيل الدخول أولاً', backgroundColor: Colors.red, textColor: Colors.white);
        return;
      }

      await FirebaseFirestore.instance.collection('restaurants').add({
        'name': _nameController.text,
        'price': _priceController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'imageUrl': 'assets/ServTech.png',
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': userPhone, // Add the user's phone number
      });

      if (mounted) {
        Fluttertoast.showToast(msg: 'تم إضافة المطعم بنجاح', backgroundColor: const Color(0xff184c6b), textColor: Colors.white);
        Navigator.pop(context);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'حدث خطأ. الرجاء المحاولة مرة أخرى', backgroundColor: Colors.red, textColor: Colors.white);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleImageTap() {
    Fluttertoast.showToast(msg: 'خاصية رفع الصور غير متاحة حالياً', backgroundColor: const Color(0xff184c6b), textColor: Colors.white);
    // TODO: Implement Firebase Storage image upload functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 60), // Space for back button
                      const Text('إضافة مطعم', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                      const SizedBox(height: 24),

                      // Image Upload Placeholder
                      Center(
                        child: GestureDetector(
                          onTap: _handleImageTap,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xff184c6b), width: 2, style: BorderStyle.solid),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 3)),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset('assets/ServTech.png', width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                                ),
                                Container(
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(14)),
                                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 40),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Existing form fields
                      buildFormField('اسم المطعم', _nameController),
                      const SizedBox(height: 16),
                      buildFormField('السعر', _priceController),
                      const SizedBox(height: 16),
                      buildFormField('الموقع', _locationController),
                      const SizedBox(height: 16),
                      buildFormField('الوصف', _descriptionController, maxLines: 5),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitRestaurant,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffc29424),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('اضافة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Back Button
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xff184c6b)), onPressed: () => Navigator.pop(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFormField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.black), // Changed to black text
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200], // Changed to match login page
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
