import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editprofile.dart';
import 'opinion.dart';
import 'screens/premium_instructions.dart'; // Update this import

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadPremiumStatus();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'زائر';
    });
  }

  Future<void> _loadPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userPhone = prefs.getString('phone');

    if (userPhone != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userPhone).get();

      if (doc.exists) {
        setState(() {
          isPremium = doc.data()?['isPremium'] ?? false;
        });
      }
    }
  }

  Widget _buildPremiumSection() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                isPremium ? 'أنت عميل مميز ✅' : 'أنت لست عميلًا مميزًا ❌',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isPremium ? Colors.green : Colors.red),
              ),
              const SizedBox(width: 8),
              Icon(Icons.star, color: isPremium ? const Color(0xffc29424) : Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  PremiumInstructionsScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff184c6b),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                'الاشتراك في الباقة المميزة',
                style: TextStyle(fontSize: 16, color: Colors.white),
                ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xff184c6b)), onPressed: () => Navigator.pop(context)),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              // Updated header with greeting
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'أهلاً، ',
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff184c6b), height: 1.2),
                          ),
                          TextSpan(
                            text: userName,
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: Color(0xffc29424), height: 1.2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),

              // Profile Options
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildProfileOption(
                        context: context,
                        icon: Icons.person_outline,
                        title: 'الصفحة الشخصية',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage())),
                      ),
                      const SizedBox(height: 15),
                      _buildProfileOption(
                        context: context,
                        icon: Icons.settings,
                        title: 'التواصل مع الادارة',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OpinionPage(restaurantName: 'تواصل معنا'))),
                      ),
                      const SizedBox(height: 15),
                      _buildProfileOption(context: context, icon: Icons.logout, title: 'تسجيل خروج', onTap: () => _showLogoutDialog(context)),
                      _buildPremiumSection(), // Add this line
                    ],
                  ),
                ),
              ),

              // Branded Footer
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xff184c6b),
                  // Optional gradient effect
                  gradient: LinearGradient(
                    colors: [const Color(0xff184c6b), const Color(0xff184c6b).withOpacity(0.9)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  // Optional subtle shadow at the top
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, -1), blurRadius: 4)],
                ),
                alignment: Alignment.center,
                // padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                child: const Text(
                  'ServTech',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white), // letterSpacing: 1.5, height: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({required BuildContext context, required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xff184c6b), size: 24),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff184c6b)))),
              const Icon(Icons.chevron_right, color: Color(0xff184c6b), size: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تسجيل خروج', textAlign: TextAlign.right, style: TextStyle(color: Color(0xff184c6b))),
          content: const Text('هل أنت متأكد من تسجيل الخروج؟', textAlign: TextAlign.right),
          actions: [
            TextButton(
              child: const Text('نعم', style: TextStyle(color: Color(0xff184c6b))),
              onPressed: () async {
                // Clear all SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                if (mounted) {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.pushReplacementNamed(context, '/'); // Navigate to login
                }
              },
            ),
            TextButton(child: const Text('لا', style: TextStyle(color: Colors.grey)), onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }
}
