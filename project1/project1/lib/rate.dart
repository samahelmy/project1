import 'package:flutter/material.dart';

class Rate extends StatelessWidget {
  const Rate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      appBar: AppBar(
        title: const Text('Rate Services'),
      ),
      body: const Center(
        child: Text('Rate Services Page'),
      ),
    );
  }
}
