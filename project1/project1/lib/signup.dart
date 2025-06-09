import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCheckingPhone = false;
  String? _phoneError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/ServTech.png'), fit: BoxFit.contain)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'الاسم الكامل',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'نرجوا إدخال الاسم الكامل';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Email / Phone Field
                    TextFormField(
                      controller: _emailController,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'رقم الهاتف',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        errorText: _phoneError,
                        suffixIcon:
                            _isCheckingPhone
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xffc29424)),
                                  ),
                                )
                                : null,
                      ),
                      onChanged: (value) {
                        // Clear error when user types
                        if (_phoneError != null) {
                          setState(() => _phoneError = null);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'نرجوا إدخال رقم الهاتف';
                        }
                        if (!RegExp(r'^(010|011|012|015)\d{8}$').hasMatch(value)) {
                          return 'الرجاء إدخال رقم هاتف مصري صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'كلمة السر',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'نرجو إدخال كلمة السر';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Confirm Password Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'اعادة كلمة السر',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'نرجوا اعادة إدخال كلمة السر';
                        }
                        if (value != _passwordController.text) {
                          return 'كلمة السر غير متطابقة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc29424),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("انشاء حساب", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text('تسجيل الدخول', style: TextStyle(color: Color(0xff184c6b))),
                        ),
                        const Text("هل لديك حساب؟"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add new method to check phone existence
  Future<bool> _isPhoneRegistered(String phone) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(phone).get();
    return doc.exists;
  }

  // Update the _signUp method
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCheckingPhone = true;
      _phoneError = null;
    });

    try {
      String phone = _emailController.text.trim();

      // Check if phone exists
      final phoneExists = await _isPhoneRegistered(phone);
      if (phoneExists) {
        setState(() {
          _phoneError = 'رقم الهاتف مسجل بالفعل. الرجاء استخدام رقم آخر أو تسجيل الدخول';
          _isCheckingPhone = false;
        });
        return;
      }

      // Prepare user data
      final userData = {
        'name': _nameController.text.trim(),
        'phone': phone,
        'password': _passwordController.text,
        'role': 'user',
        'isPremium': true,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Create user document in Firestore
      await FirebaseFirestore.instance.collection('users').doc(phone).set(userData);

      // Save user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', phone);
      await prefs.setString('name', userData['name'] as String);
      await prefs.setString('role', userData['role']as String);
      await prefs.setBool('isPremium', userData['isPremium']as bool);

      if (mounted) {
        Fluttertoast.showToast(msg: "تم إنشاء الحساب بنجاح", backgroundColor: Colors.green);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const homepage()));
      }
    } catch (e) {
      setState(() => _phoneError = 'حدث خطأ. الرجاء المحاولة مرة أخرى');
      print('Error signing up: $e');
    } finally {
      if (mounted) {
        setState(() => _isCheckingPhone = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
