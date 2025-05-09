
import 'package:flutter/material.dart';
import 'package:project1/Jobs.dart';
import 'package:project1/Sell.dart';


class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);



  @override
  State<homepage> createState() => _homepageState();
}


int _currentIndex = 0;

  final List<Widget> _pages = [
     const Center(child: Text('Home Page')), 
    const Jobs(key: Key('jobs')),
    const Sell(key: Key('sell')),
  ];


class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sell'),
        ],
      ),
    );
  }
}