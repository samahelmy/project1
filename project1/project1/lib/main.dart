import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'signup.dart';
import 'models/rating_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RatingProvider(),
      child: MaterialApp(
        title: 'Three Page App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginPage(),
        routes: {
          '/signup': (context) => const SignupPage(),
          '/main': (context) => const MainPage(),
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold configuration
    );
  }
}

