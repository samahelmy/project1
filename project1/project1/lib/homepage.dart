import 'package:flutter/material.dart';
import 'package:project1/Jobs.dart';
import 'package:project1/Sell.dart';
import 'package:project1/buying.dart';
import 'package:project1/resproducts.dart';
import 'package:project1/rate.dart';

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
      backgroundColor: const Color(0xFFF7F6F2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Logo
              Container(
                height: 250,  // Increased from 150
                width: 250,   // Increased from 150
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/ServTech.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // First row of containers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildClickableContainer('Container 1'),
                  _buildClickableContainer('Container 2'),
                ],
              ),
              const SizedBox(height: 20),
              // Second row of containers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildClickableContainer('Container 3'),
                  _buildClickableContainer('Container 4'),
                ],
              ),
              const SizedBox(height: 20),
              // Bottom container
              _buildClickableContainer('Bottom Container', isWide: true),
              // Add extra padding at bottom to prevent content from being hidden by nav bar
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
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

  Widget _buildClickableContainer(String text, {bool isWide = false}) {
    return InkWell(
      onTap: () {
        if (text == 'Container 1') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Jobs()),
          );
        } else if (text == 'Container 2') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Buying()),
          );
        } else if (text == 'Container 3') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResProducts()),
          );
        } else if (text == 'Container 4') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Rate()),
          );
        }
      },
      child: Container(
        width: isWide 
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * 0.4,
        height: isWide ? 70 : 180,  // Increased regular height to 180, bottom container to 70
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isWide 
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.help_outline,  // Changed icon for bottom container
                    size: 30,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIconForContainer(text),
                    size: 50,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  IconData _getIconForContainer(String text) {
    switch (text) {
      case 'Container 1':
        return Icons.handyman;
      case 'Container 2':
        return Icons.engineering;
      case 'Container 3':
        return Icons.home_repair_service;
      case 'Container 4':
        return Icons.build;
      default:
        return Icons.error;
    }
  }
}