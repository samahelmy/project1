import 'package:flutter/material.dart';
import 'homepage.dart';
import 'jobs.dart';
import 'sell.dart';
import 'login.dart';
import 'signup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Three Page App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      routes: {
        '/signup': (context) => const SignupPage(),
        '/main': (context) => const MainPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
    );
  }
}

