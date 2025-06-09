import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String? userPhone;

  @override
  void initState() {
    super.initState();
    _loadUserPhone();
    WidgetsBinding.instance.addPostFrameCallback((_) => _markNotificationsAsRead());
  }

  Future<void> _loadUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhone = prefs.getString('phone');
    });
  }

  Future<void> _markNotificationsAsRead() async {
    if (userPhone == null) return;

    final batch = FirebaseFirestore.instance.batch();
    final notifications =
        await FirebaseFirestore.instance.collection('users').doc(userPhone).collection('notifications').where('isRead', isEqualTo: false).get();

    for (var doc in notifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    if (userPhone == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xffc29424))));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffc29424),
        title: const Text('الإشعارات', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(userPhone)
                .collection('notifications')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Color(0xffc29424)));
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد إشعارات حالياً', style: TextStyle(fontSize: 18, color: Color(0xff184c6b))));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final timestamp = (data['timestamp'] as Timestamp).toDate();
              final formattedDate = DateFormat('yyyy/MM/dd - HH:mm').format(timestamp);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(data['title'] ?? 'إشعار جديد', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff184c6b))),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(data['message'] ?? ''),
                      const SizedBox(height: 4),
                      Text(formattedDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  leading: const CircleAvatar(backgroundColor: Color(0xffc29424), child: Icon(Icons.notifications, color: Colors.white)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
