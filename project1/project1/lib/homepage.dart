import 'package:flutter/material.dart';
import 'package:project1/Jobs.dart';
import 'package:project1/buying.dart';
import 'package:project1/resproducts.dart';
import 'package:project1/rate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'login.dart';
import 'notifications_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/notification_badge.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> with TickerProviderStateMixin, RouteAware {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _fadeAnimations = [];
  final List<Animation<Offset>> _slideAnimations = [];
  RouteObserver<PageRoute>? _routeObserver;

  String? userPhone;

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!context.mounted) return;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserPhone();
    // Add this line to start animations after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startStaggeredAnimations();
    });
  }

  Future<void> _loadUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhone = prefs.getString('phone');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the RouteObserver from MaterialApp
    _routeObserver = Navigator.of(context).widget.observers.whereType<RouteObserver<PageRoute>>().first;
    _routeObserver?.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeAnimations() {
    // Clear existing animations if any
    for (var controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    _fadeAnimations.clear();
    _slideAnimations.clear();

    // Create new animations
    for (int i = 0; i < 4; i++) {
      final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

      _controllers.add(controller);

      _fadeAnimations.add(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      _slideAnimations.add(
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutQuad)),
      );
    }
  }

  void _startStaggeredAnimations() async {
    // Reset all controllers first
    for (var controller in _controllers) {
      controller.reset();
    }

    // Start animations with delay
    for (var i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) {
        _controllers[i].forward();
      }
    }
  }

  @override
  void didPushNext() {
    // Reset animations when leaving the page
    for (var controller in _controllers) {
      controller.reset();
    }
  }

  @override
  void didPopNext() {
    super.didPopNext();
    // Restart animations when returning to the page
    _startStaggeredAnimations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  // Logo
                  Container(
                    height: 250, // Increased from 150
                    width: 250, // Increased from 150
                    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/ServTech.png'), fit: BoxFit.contain)),
                  ),
                  const SizedBox(height: 40),
                  // First row of containers with animations
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [_buildClickableContainer('التوظيف'), _buildClickableContainer('بيع وشراء وتأجير المطاعم')],
                    ),
                  ),

                  // Second row of containers with animations
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [_buildClickableContainer('شراء وتأجير معدات الطعام'), _buildClickableContainer('التقييم')],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Top right - Profile icon
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xff184c6b))),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
            ),
          ),
          // Top left - Notifications icon
          _buildNotificationIcon(),
        ],
      ),
    );
  }

  // Update the _buildClickableContainer method to use animations
  Widget _buildClickableContainer(String text, {bool isWide = false}) {
    // Get the index for this container
    int index;
    switch (text) {
      case 'التوظيف':
        index = 0;
        break;
      case 'بيع وشراء وتأجير المطاعم':
        index = 1;
        break;
      case 'شراء وتأجير معدات الطعام':
        index = 2;
        break;
      case 'التقييم':
        index = 3;
        break;
      default:
        index = 0;
    }

    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: InkWell(
          onTap: () {
            if (text == 'التوظيف') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Jobs()), // Removed const
              );
            } else if (text == 'بيع وشراء وتأجير المطاعم') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Buying()));
            } else if (text == 'شراء وتأجير معدات الطعام') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ResProducts()));
            } else if (text == 'التقييم') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Rate()));
            }
          },
          child: Container(
            width: isWide ? MediaQuery.of(context).size.width * 0.5 : MediaQuery.of(context).size.width * 0.4,
            height: isWide ? 70 : 180, // Increased regular height to 180, bottom container to 70
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
            ),
            child:
                isWide
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_outlined, // Changed icon for bottom container
                          size: 30,
                          color: const Color(0xffc29424), // Updated color
                        ),
                        const SizedBox(width: 10),
                        Text("التواصل مع الادارة", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    )
                    : Column(
                      children: [
                        Expanded(
                          flex: 3, // Takes 60% of container height
                          child: Center(
                            child: Icon(
                              _getIconForContainer(text),
                              size: 80, // Increased from 65
                              color: const Color(0xffc29424),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2, // Takes 40% of container height
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18, // Increased from 15
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForContainer(String text) {
    switch (text) {
      case 'التوظيف':
        return Icons.person_add_sharp;
      case 'بيع وشراء وتأجير المطاعم':
        return Icons.store;
      case 'شراء وتأجير معدات الطعام':
        return Icons.room_service_rounded;
      case 'التقييم':
        return Icons.star_rounded;
      default:
        return Icons.error;
    }
  }

  Widget _buildNotificationIcon() {
    return Positioned(
      top: 40,
      left: 20,
      child: StreamBuilder<QuerySnapshot>(
        stream:
            userPhone != null
                ? FirebaseFirestore.instance
                    .collection('users')
                    .doc(userPhone)
                    .collection('notifications')
                    .where('isRead', isEqualTo: false)
                    .snapshots()
                : null,
        builder: (context, snapshot) {
          final unreadCount = snapshot.hasData ? snapshot.data!.docs.length : 0;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.notifications, color: Color(0xff184c6b))),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage()));
                },
              ),
              NotificationBadge(count: unreadCount),
            ],
          );
        },
      ),
    );
  }
}
