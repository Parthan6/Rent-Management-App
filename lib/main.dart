import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'splash_screen.dart';

void main() {
  runApp(RentManagementApp());
}

class RentManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
