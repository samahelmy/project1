class SellerRequest {
  final String userId;
  final String name;
  final String phone;
  final DateTime requestedAt;
  final String status;

  SellerRequest({required this.userId, required this.name, required this.phone, required this.requestedAt, this.status = 'pending_seller'});

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'name': name, 'phone': phone, 'requestedAt': requestedAt, 'status': status};
  }
}
