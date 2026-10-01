import 'package:flutter/material.dart';
import 'package:expensewise/features/home/presentation/screens/home_screen.dart';

void main() {
  runApp(const ExpenseWiseApp());
}

class ExpenseWiseApp extends StatelessWidget {
  const ExpenseWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpenseWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
