import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/seller_request_notification.dart';

class SellerRequestsPage extends StatefulWidget {
  final String adminPhone;

  const SellerRequestsPage({super.key, required this.adminPhone});

  @override
  State<SellerRequestsPage> createState() => _SellerRequestsPageState();
}

class _SellerRequestsPageState extends State<SellerRequestsPage> {
  bool _isLoading = false;

  Future<void> _handleApprove(SellerRequestNotification request) async {
    setState(() => _isLoading = true);

    try {
      // Update user role
      await FirebaseFirestore.instance.collection('users').doc(request.requesterId).update({'role': 'seller', 'sellerRequest': FieldValue.delete()});

      // Send notification to user
      await FirebaseFirestore.instance.collection('users').doc(request.requesterId).collection('notifications').add({
        'title': 'تم قبول طلبك',
        'message': 'تم قبول طلبك لتصبح بائعاً. يمكنك الآن إضافة منتجات للبيع.',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      // Mark admin notification as read
      await FirebaseFirestore.instance.collection('users').doc(widget.adminPhone).collection('notifications').doc(request.id).update({
        'isRead': true,
      });

      Fluttertoast.showToast(msg: 'تم قبول الطلب بنجاح');
    } catch (e) {
      Fluttertoast.showToast(msg: 'حدث خطأ في معالجة الطلب');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleReject(SellerRequestNotification request) async {
    setState(() => _isLoading = true);

    try {
      // Remove seller request
      await FirebaseFirestore.instance.collection('users').doc(request.requesterId).update({'sellerRequest': FieldValue.delete()});

      // Send notification to user
      await FirebaseFirestore.instance.collection('users').doc(request.requesterId).collection('notifications').add({
        'title': 'تم رفض طلبك',
        'message': 'عذراً، تم رفض طلبك لتصبح بائعاً. يمكنك التواصل مع الإدارة لمزيد من المعلومات.',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      // Mark admin notification as read
      await FirebaseFirestore.instance.collection('users').doc(widget.adminPhone).collection('notifications').doc(request.id).update({
        'isRead': true,
      });

      Fluttertoast.showToast(msg: 'تم رفض الطلب');
    } catch (e) {
      Fluttertoast.showToast(msg: 'حدث خطأ في معالجة الطلب');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xff184c6b), title: const Text('طلبات البائعين'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.adminPhone)
            .collection('notifications')
            .where('type', isEqualTo: 'seller_request')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .handleError((error) {
              if (error.toString().contains('indexes')) {
                Fluttertoast.showToast(msg: 'جاري تهيئة قاعدة البيانات، يرجى الانتظار قليلاً...', toastLength: Toast.LENGTH_LONG);
              }
              return Stream.empty();
            }),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          if (notifications.isEmpty) {
            return const Center(child: Text('لا توجد طلبات جديدة', style: TextStyle(fontSize: 18, color: Color(0xff184c6b))));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final data = notification.data() as Map<String, dynamic>;
              final requesterId = data['requesterId'] as String;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(requesterId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final request = SellerRequestNotification.fromFirestore(notification, userSnapshot.data?.data() as Map<String, dynamic>?);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(request.timestamp.toLocal().toString().split('.')[0], style: const TextStyle(color: Colors.grey, fontSize: 14)),
                              Text(
                                request.requesterName ?? 'غير معروف',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff184c6b)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            request.requesterPhone ?? '',
                            style: const TextStyle(fontSize: 16, color: Color(0xffc29424)),
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(height: 16),
                          Text(request.message, style: const TextStyle(fontSize: 16), textAlign: TextAlign.right),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _isLoading ? null : () => _handleReject(request),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                child: const Text('رفض'),
                              ),
                              ElevatedButton(
                                onPressed: _isLoading ? null : () => _handleApprove(request),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                child: const Text('قبول'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
