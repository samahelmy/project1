import 'package:flutter/material.dart';

class AvailabilityBadge extends StatefulWidget {
  final bool isAvailable;
  final bool showUnavailable;

  const AvailabilityBadge({super.key, required this.isAvailable, this.showUnavailable = false});

  @override
  State<AvailabilityBadge> createState() => _AvailabilityBadgeState();
}

class _AvailabilityBadgeState extends State<AvailabilityBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAvailable && !widget.showUnavailable) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isAvailable ? _scaleAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: widget.isAvailable ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.isAvailable ? Colors.green : Colors.grey, width: 1),
            ),
            child: Text(
              widget.isAvailable ? 'متاح' : 'غير متاح',
              style: TextStyle(color: widget.isAvailable ? Colors.green : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
