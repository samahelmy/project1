import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Add these variables to track error states
  String? phoneError;
  String? passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/ServTech.png'), fit: BoxFit.contain)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Phone field
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
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'نرجوا إدخال رقم الهاتف';
                        }
                        return null;
                      },
                    ),
                    if (phoneError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(phoneError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ),
                    const SizedBox(height: 20),
                    // Password field
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
                    if (passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(passwordError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc29424),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text('انشاء حساب', style: TextStyle(color: Color(0xff184c6b))),
                        ),
                        const Text("ليس لديك حساب؟", style: TextStyle(color: Colors.black)),
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

  Future<void> _login() async {
    // Reset error messages
    setState(() {
      phoneError = null;
      passwordError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    try {
      String phone = _emailController.text.trim();
      // String encodedPassword = base64.encode(utf8.encode(_passwordController.text));

      // Validate phone number format
      if (!RegExp(r'^(010|011|012|015)\d{8}$').hasMatch(phone)) {
        setState(() {
          phoneError = "الرجاء إدخال رقم هاتف مصري صحيح";
        });
        return;
      }

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(phone).get();

      if (!userDoc.exists) {
        setState(() {
          phoneError = 'رقم الهاتف غير مسجل';
        });
        return;
      }

      final userData = userDoc.data()!;
      if (userData['password'] != _passwordController.text) {
        setState(() {
          passwordError = 'كلمة المرور غير صحيحة';
        });
        return;
      }

      // Save user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', phone);
      await prefs.setString('name', userData['name']);
      await prefs.setString('role', userData['role']);
      await prefs.setBool('isPremium', userData['isPremium']);

      Fluttertoast.showToast(msg: "تم تسجيل الدخول بنجاح", backgroundColor: Colors.green);

      if (userData['role'] == 'admin') {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/admin');
        }
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      setState(() {
        passwordError = 'حدث خطأ. الرجاء المحاولة مرة أخرى';
      });
      print('Error logging in: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
