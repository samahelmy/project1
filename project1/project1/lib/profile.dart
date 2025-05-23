import 'package:flutter/material.dart';
import 'editprofile.dart';
import 'opinion.dart'; // Add this import

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 60),
              // Profile Header
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xff184c6b),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'User Name',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff184c6b),
                      ),
                    ),
                    const SizedBox(height: 40), // Increased height to maintain spacing
                    // Profile Options
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          buildProfileOption(context, Icons.person_outline, 'الصفحة الشخصية'),
                          const SizedBox(height: 15),
                          buildProfileOption(context, Icons.settings, 'التواصل مع الادارة'),
                          const SizedBox(height: 15),
                          buildProfileOption(context, Icons.help_outline, 'تسجيل خروج'),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Profile Options
             
            ],
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff184c6b),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileOption(BuildContext context, IconData icon, String title) {
    return InkWell(
      onTap: () {
        switch (title) {
          case 'الصفحة الشخصية':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfilePage()),
            );
            break;
          case 'التواصل مع الادارة':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OpinionPage(restaurantName: 'تواصل معنا'),
              ),
            );
            break;
          case 'تسجيل خروج':
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'تسجيل خروج',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Color(0xff184c6b)),
                  ),
                  content: const Text(
                    'هل أنت متأكد من تسجيل الخروج؟',
                    textAlign: TextAlign.right,
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        'لا',
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'نعم',
                        style: TextStyle(color: Color(0xff184c6b)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.pushReplacementNamed(context, '/'); // Go to login
                      },
                    ),
                  ],
                );
              },
            );
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xff184c6b),
              size: 24,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xff184c6b),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
