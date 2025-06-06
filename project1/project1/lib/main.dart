import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'splash.dart';
import 'login.dart';
import 'signup.dart';
import 'homepage.dart';
import 'models/rating_provider.dart';
import 'firebase_options.dart';
import 'admin/admin_dashboard.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RatingProvider(),
      child: MaterialApp(
        title: 'ServTech',
        theme: ThemeData(primarySwatch: Colors.blue),
        navigatorObservers: [routeObserver],
        home: const SplashScreen(),
        routes: {
          '/signup': (context) => const SignupPage(),
          '/home': (context) => const homepage(),
          '/login': (context) => const LoginPage(),
          '/admin': (context) => const AdminDashboard(),
        },
      ),
    );
  }
}
