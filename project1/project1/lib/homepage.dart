import 'package:flutter/material.dart';
import 'package:project1/Jobs.dart';
import 'package:project1/Sell.dart';
import 'package:project1/buying.dart';
import 'package:project1/resproducts.dart';
import 'package:project1/rate.dart';
import 'profile.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
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
                      _buildClickableContainer('التوظيف'),
                      _buildClickableContainer('بيع وشراء وتأجير المطاعم'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Second row of containers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildClickableContainer('شراء وتأجير معدات الطعام'),
                      _buildClickableContainer('التقييم'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Bottom container
                  _buildClickableContainer('Contact Us', isWide: true),
                ],
              ),
            ),
          ),
          // Left logout button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.logout,
                color: Color(0xff184c6b),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
          // Right settings button
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.person,
                  color: Color(0xff184c6b),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableContainer(String text, {bool isWide = false}) {
    return InkWell(
      onTap: () {
        if (text == 'التوظيف') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Jobs()),
          );
        } else if (text == 'بيع وشراء وتأجير المطاعم') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Buying()),
          );
        } else if (text == 'شراء وتأجير معدات الطعام') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResProducts()),
          );
        } else if (text == 'التقييم') {
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
                    Icons.chat_outlined,  // Changed icon for bottom container
                    size: 30,
                    color: const Color(0xffc29424), // Updated color
                  ),
                  const SizedBox(width: 10),
                  Text(
                   "التواصل مع الادارة",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
}