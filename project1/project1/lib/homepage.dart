import 'package:flutter/material.dart';
import 'package:project1/Jobs.dart';
import 'package:project1/Sell.dart';
import 'package:project1/buying.dart';
import 'package:project1/resproducts.dart';
import 'package:project1/rate.dart';

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
                  _buildClickableContainer('Find Services'),
                  _buildClickableContainer('Buy Products'),
                ],
              ),
              const SizedBox(height: 20),
              // Second row of containers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildClickableContainer('Our Packages'),
                  _buildClickableContainer('Rate Services'),
                ],
              ),
              const SizedBox(height: 20),
              // Bottom container
              _buildClickableContainer('Contact Us', isWide: true),
            ],
          ),
        ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIconForContainer(text),
                    size: 50,
                    color: const Color(0xffc29424), // Updated color
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
      case 'Find Services':
        return Icons.person_add_sharp;
      case 'Buy Products':
        return Icons.store;
      case 'Our Packages':
        return Icons.room_service_rounded;
      case 'Rate Services':
        return Icons.star_rounded;
      default:
        return Icons.error;
    }
  }
}