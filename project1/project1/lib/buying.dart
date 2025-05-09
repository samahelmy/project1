import 'package:flutter/material.dart';

class Buying extends StatelessWidget {
  const Buying({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(
        title: const Text('Buying'),
      ),
      body: const Center(
        child: Text('Buying Page'),
      ),
    );
  }
}
