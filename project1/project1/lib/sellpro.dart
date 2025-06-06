import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellPro extends StatefulWidget {
  const SellPro({super.key});

  @override
  State<SellPro> createState() => _SellProState();
}

class _SellProState extends State<SellPro> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitEquipment() async {
    // Validate fields
    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _descriptionController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'جميع الحقول مطلوبة', backgroundColor: Colors.red, textColor: Colors.white);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Get user phone from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userPhone = prefs.getString('phone'); // Make sure this matches your login key

      // Upload to Firestore with phone number
      await FirebaseFirestore.instance.collection('equipment').add({
        'name': _nameController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'imageUrl': 'assets/ServTech.png', // TODO: Implement Firebase Storage
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': userPhone ?? '', // Add the phone number
      });

      Fluttertoast.showToast(msg: 'تم إضافة المنتج بنجاح', backgroundColor: const Color(0xff184c6b), textColor: Colors.white);

      if (mounted) {
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
    Fluttertoast.showToast(msg: 'ميزة رفع الصورة غير مفعلة حالياً', backgroundColor: const Color(0xff184c6b), textColor: Colors.white);
    // TODO: Implement Firebase Storage image upload
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
                const SizedBox(height: 60),
                // Title (kept as is)
                const Center(child: Text('إضافة معدات مطاعم', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color(0xff184c6b)))),
                const SizedBox(height: 30),

                // Image Selection Area
                Center(
                  child: GestureDetector(
                    onTap: _handleImageTap,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xff184c6b), width: 2),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset('assets/ServTech.png', width: 180, height: 180, fit: BoxFit.contain),
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
                const SizedBox(height: 30),

                // Form Fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('اسم المنتج / المعدة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                      const SizedBox(height: 8),
                      buildFormField('اسم المنتج / المعدة', _nameController),
                      const SizedBox(height: 20),

                      const Text('السعر', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                      const SizedBox(height: 8),
                      buildFormField('السعر', _priceController),
                      const SizedBox(height: 20),

                      const Text('الوصف', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                      const SizedBox(height: 8),
                      buildFormField('الوصف', _descriptionController, maxLines: 4),
                      const SizedBox(height: 30),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitEquipment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffc29424),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('إضافة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
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
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey, width: 1)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }
}
