import 'package:flutter/material.dart';

class AnimatedPageWrapper extends StatefulWidget {
  final Widget child;
  final bool animate;
  final Duration duration;

  const AnimatedPageWrapper({super.key, required this.child, this.animate = true, this.duration = const Duration(milliseconds: 600)});

  @override
  State<AnimatedPageWrapper> createState() => _AnimatedPageWrapperState();
}

class _AnimatedPageWrapperState extends State<AnimatedPageWrapper> with SingleTickerProviderStateMixin, RouteAware {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _offset = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));

    if (widget.animate) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _controller.forward(from: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      final observer = Navigator.of(context).widget.observers.whereType<RouteObserver<ModalRoute<void>>>().firstOrNull;
      if (observer != null) {
        observer.subscribe(this, modalRoute as PageRoute);
      }
    }
  }

  @override
  void didPopNext() {
    _startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(opacity: _opacity.value, child: FractionalTranslation(translation: _offset.value, child: child));
      },
      child: widget.child,
    );
  }
}
