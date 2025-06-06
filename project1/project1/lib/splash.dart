import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'homepage.dart';
import 'admin/admin_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString('phone');

      // Wait for minimum 2 seconds to show splash screen
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // If no phone stored, redirect to login
      if (phone == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        return;
      }

      // Fetch user document from Firestore
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(phone).get();

      if (!mounted) return;

      // Check if user exists and has a role
      if (!userDoc.exists) {
        // Clear invalid preferences and redirect to login
        await prefs.clear();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        return;
      }

      final role = userDoc.data()?['role'] as String?;

      // Navigate based on role
      if (role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
      } else if (role == 'user') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const homepage()));
      } else {
        // Invalid role, clear preferences and redirect to login
        await prefs.clear();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'حدث خطأ في تحميل البيانات';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/ServTech.png', width: MediaQuery.of(context).size.width * 0.7),
            if (_isLoading) ...[const SizedBox(height: 32), const CircularProgressIndicator(color: Color(0xffc29424))],
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(_errorMessage!, style: const TextStyle(color: Color(0xff184c6b), fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _isLoading = true;
                  });
                  _checkUserRole();
                },
                child: const Text('إعادة المحاولة', style: TextStyle(color: Color(0xffc29424), fontSize: 16)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
