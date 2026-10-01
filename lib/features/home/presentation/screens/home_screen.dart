import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ExpenseWise')),
      body: const Center(
        child: Text('ExpenseWise app skeleton'),
      ),
    );
  }
}
