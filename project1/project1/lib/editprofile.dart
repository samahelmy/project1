import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isEditing = false;
  bool isLoading = true;
  String? userPhone;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  String selectedGender = 'ذكر';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    try {
      // Get phone from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      userPhone = prefs.getString('phone');

      if (userPhone != null) {
        // Fetch user data from Firestore
        final doc = await FirebaseFirestore.instance.collection('users').doc(userPhone).get();

        if (doc.exists) {
          final data = doc.data()!;
          setState(() {
            nameController.text = data['name'] ?? '';
            phoneController.text = data['phone'] ?? '';
            passwordController.text = data['password'] ?? '';
            addressController.text = data['address'] ?? '';
            selectedGender = data['gender'] ?? 'ذكر';
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'حدث خطأ في تحميل البيانات');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (userPhone == null) return;

    setState(() => isLoading = true);

    try {
      final updates = <String, dynamic>{
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text,
        'address': addressController.text.trim(),
        'gender': selectedGender,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('users').doc(userPhone).update(updates);

      Fluttertoast.showToast(msg: 'تم حفظ التغييرات بنجاح');
      setState(() => isEditing = false);
    } catch (e) {
      Fluttertoast.showToast(msg: 'حدث خطأ في حفظ البيانات');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Stack(
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator(color: Color(0xffc29424)))
          else
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Center(
                    child: CircleAvatar(radius: 60, backgroundColor: Colors.white, child: Icon(Icons.person, size: 60, color: Color(0xff184c6b))),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        buildEditableRow('الاسم', nameController),
                        const SizedBox(height: 20),
                        buildEditableRow('رقم الجوال', phoneController),
                        const SizedBox(height: 20),
                        buildEditableRow('كلمة المرور', passwordController, isPassword: true),
                        const SizedBox(height: 20),
                        buildEditableRow('العنوان', addressController),
                        const SizedBox(height: 20),
                        buildGenderSelector(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          // Top Actions
          Positioned(
            top: 40,
            right: 20,
            child: TextButton.icon(
              onPressed:
                  isLoading
                      ? null
                      : () {
                        setState(() {
                          if (isEditing) {
                            _saveChanges();
                          } else {
                            isEditing = true;
                          }
                        });
                      },
              icon: Icon(isEditing ? Icons.save : Icons.edit, color: const Color(0xff184c6b)),
              label: Text(isEditing ? 'حفظ' : 'تعديل', style: const TextStyle(color: Color(0xff184c6b), fontSize: 16)),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xff184c6b)), onPressed: () => Navigator.pop(context)),
          ),
        ],
      ),
    );
  }

  Widget buildEditableRow(String label, TextEditingController controller, {bool isPassword = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isEditing)
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              obscureText: isPassword,
              cursorColor: const Color(0xff184c6b),
              decoration: InputDecoration(
                hintText: isPassword ? '••••••' : 'أدخل ${label.toLowerCase()}',
                hintTextDirection: TextDirection.rtl,
                border: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff184c6b))),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff184c6b))),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffc29424), width: 2)),
              ),
            ),
          )
        else
          Text(
            isPassword ? '••••••' : (controller.text.isEmpty ? 'غير محدد' : controller.text),
            style: TextStyle(fontSize: 18, color: controller.text.isEmpty ? Colors.grey : Colors.black87),
          ),
        const SizedBox(width: 20),
        Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
      ],
    );
  }

  Widget buildGenderSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isEditing)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: const Color(0xFFF7F6F2), borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
              value: selectedGender,
              items:
                  ['ذكر', 'انثى'].map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontSize: 18, color: Color(0xff184c6b))));
                  }).toList(),
              onChanged: (newValue) {
                setState(() => selectedGender = newValue!);
              },
              underline: Container(),
            ),
          )
        else
          Text(selectedGender, style: const TextStyle(fontSize: 18, color: Colors.black87)),
        const SizedBox(width: 20),
        const Text('الجنس', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
