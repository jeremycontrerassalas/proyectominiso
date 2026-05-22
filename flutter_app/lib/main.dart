import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retail Products',
      theme: ThemeData(primarySwatch: Colors.indigo),
      routes: {
        '/': (context) => const HomeScreen(),
        '/add': (context) => const AddProductScreen(),
      },
    );
  }
}
