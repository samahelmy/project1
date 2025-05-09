import 'package:flutter/material.dart';

class ResProducts extends StatelessWidget {
  const ResProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(
        title: const Text('Residential Products'),
      ),
      body: const Center(
        child: Text('Residential Products Page'),
      ),
    );
  }
}
