import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'users_page.dart';
import 'content_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  Future<void> _checkAdminAccess() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone');

    if (phone != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(phone).get();

      if (mounted) {
        setState(() {
          _isAdmin = userDoc.data()?['role'] == 'admin';
          _isLoading = false;
        });
      }

      if (!_isAdmin && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  // Fetch total users count
  Stream<int> _getUserCount() {
    return FirebaseFirestore.instance.collection('users').snapshots().map((snap) => snap.size);
  }

  // Fetch restaurants count
  Stream<int> _getRestaurantsCount() {
    return FirebaseFirestore.instance.collection('restaurants').snapshots().map((snap) => snap.size);
  }

  // Fetch equipment count
  Stream<int> _getEquipmentCount() {
    return FirebaseFirestore.instance.collection('equipment').snapshots().map((snap) => snap.size);
  }

  // Fetch jobs count
  Stream<int> _getJobsCount() {
    return FirebaseFirestore.instance.collection('jobs').snapshots().map((snap) => snap.size);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xffc29424))));
    }

    if (!_isAdmin) {
      return const Scaffold(body: Center(child: Text('غير مصرح بالدخول')));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff184c6b),
          title: const Text('لوحة التحكم', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            AdminDashboardStats(), // Add this as first tab
            UsersPage(),
            ContentPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'لوحة المعلومات'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'المستخدمين'),
            BottomNavigationBarItem(icon: Icon(Icons.content_paste), label: 'المحتوى'),
          ],
        ),
      ),
    );
  }
}

class AdminDashboardStats extends StatelessWidget {
  const AdminDashboardStats({super.key});

  // Fetch total users count
  Stream<int> _getUserCount() {
    return FirebaseFirestore.instance.collection('users').snapshots().map((snap) => snap.size);
  }

  // Fetch restaurants count
  Stream<int> _getRestaurantsCount() {
    return FirebaseFirestore.instance.collection('restaurants').snapshots().map((snap) => snap.size);
  }

  // Fetch equipment count
  Stream<int> _getEquipmentCount() {
    return FirebaseFirestore.instance.collection('equipment').snapshots().map((snap) => snap.size);
  }

  // Fetch jobs count
  Stream<int> _getJobsCount() {
    return FirebaseFirestore.instance.collection('jobs').snapshots().map((snap) => snap.size);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('لوحة المعلومات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard(title: 'المستخدمين', icon: Icons.group, countStream: _getUserCount(), color: const Color(0xff184c6b)),
              _buildStatCard(title: 'المطاعم', icon: Icons.restaurant, countStream: _getRestaurantsCount(), color: const Color(0xffc29424)),
              _buildStatCard(title: 'المعدات', icon: Icons.build, countStream: _getEquipmentCount(), color: const Color(0xff184c6b)),
              _buildStatCard(title: 'الوظائف', icon: Icons.work, countStream: _getJobsCount(), color: const Color(0xffc29424)),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String title, required IconData icon, required Stream<int> countStream, required Color color}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: StreamBuilder<int>(
        stream: countStream,
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [color, color.withOpacity(0.8)]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                if (snapshot.hasError)
                  const Icon(Icons.error_outline, color: Colors.red)
                else if (!snapshot.hasData)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
                else
                  Text(snapshot.data.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          );
        },
      ),
    );
  }
}
