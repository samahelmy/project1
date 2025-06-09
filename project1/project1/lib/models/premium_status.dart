class PremiumStatus {
  final bool isPremium;
  final DateTime? activatedAt;
  final DateTime? expiresAt;

  const PremiumStatus({this.isPremium = false, this.activatedAt, this.expiresAt});

  factory PremiumStatus.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) return const PremiumStatus();

    return PremiumStatus(isPremium: data['isPremium'] ?? false, activatedAt: data['activatedAt']?.toDate(), expiresAt: data['expiresAt']?.toDate());
  }
}
