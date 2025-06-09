import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int count;

  const NotificationBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
