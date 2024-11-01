import 'package:flutter/material.dart';
import 'package:miogra/core/colors.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text(
          'You have no notifications',
        ),
      ),
    );
  }
}
