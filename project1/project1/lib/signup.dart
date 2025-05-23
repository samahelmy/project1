import 'package:flutter/material.dart';
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/ServTech.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space elements
                  children: [
                    TextFormField(
                      controller: _nameController,
                      textAlign: TextAlign.right,  // Changed to right
                      textDirection: TextDirection.rtl,  // Added RTL
                      decoration: InputDecoration(
                        labelText: 'الاسم الكامل',
                        alignLabelWithHint: true,  // Added for label alignment
                        floatingLabelAlignment: FloatingLabelAlignment.start,  // Added for floating label
                        filled: true,
                        fillColor: Colors.grey[200],
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
                    // Apply same decoration to email field
                    TextFormField(
                      controller: _emailController,
                      textAlign: TextAlign.right,  // Changed to right
                      textDirection: TextDirection.rtl,  // Added RTL
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        alignLabelWithHint: true,  // Added for label alignment
                        floatingLabelAlignment: FloatingLabelAlignment.start,  // Added for floating label
                        filled: true,
                        fillColor: Colors.grey[200],
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
                    const SizedBox(height: 20),
                    // Apply same decoration to password field
                    TextFormField(
                      controller: _passwordController,
                      textAlign: TextAlign.right,  // Changed to right
                      textDirection: TextDirection.rtl,  // Added RTL
                      decoration: InputDecoration(
                        labelText: 'كلمة السر',
                        alignLabelWithHint: true,  // Added for label alignment
                        floatingLabelAlignment: FloatingLabelAlignment.start,  // Added for floating label
                        filled: true,
                        fillColor: Colors.grey[200],
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
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'نرجو إدخال كلمة السر';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Apply same decoration to confirm password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      textAlign: TextAlign.right,  // Changed to right
                      textDirection: TextDirection.rtl,  // Added RTL
                      decoration: InputDecoration(
                        labelText: 'اعادة كلمة السر',
                        alignLabelWithHint: true,  // Added for label alignment
                        floatingLabelAlignment: FloatingLabelAlignment.start,  // Added for floating label
                        filled: true,
                        fillColor: Colors.grey[200],
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
                      obscureText: true,
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const homepage()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc29424),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "انشاء حساب",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          child: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(color: Color(0xff184c6b)),
                          ),
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
