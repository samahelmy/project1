import 'package:flutter/material.dart';
import 'package:project1/Jobs.dart';
import 'package:project1/Sell.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

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
                height: 150,
                width: 150,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClickableContainer(String text, {bool isWide = false}) {
    return InkWell(
      onTap: () {
        // Add your click handling here
      },
      child: Container(
        width: isWide ? double.infinity : MediaQuery.of(context).size.width * 0.4,
        height: 100,
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
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}