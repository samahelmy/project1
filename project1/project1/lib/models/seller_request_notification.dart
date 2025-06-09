import 'package:cloud_firestore/cloud_firestore.dart';

class SellerRequestNotification {
  final String id;
  final String requesterId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? requesterName;
  final String? requesterPhone;

  SellerRequestNotification({
    required this.id,
    required this.requesterId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.requesterName,
    this.requesterPhone,
  });

  factory SellerRequestNotification.fromFirestore(DocumentSnapshot doc, Map<String, dynamic>? userData) {
    final data = doc.data() as Map<String, dynamic>;

    // Convert Firestore Timestamp to DateTime
    final timestamp = data['timestamp'] as Timestamp;

    return SellerRequestNotification(
      id: doc.id,
      requesterId: data['requesterId'] ?? '',
      message: data['message'] ?? '',
      timestamp: timestamp.toDate(),
      isRead: data['isRead'] ?? false,
      requesterName: userData?['name'] as String?,
      requesterPhone: userData?['phone'] as String?,
    );
  }
}
