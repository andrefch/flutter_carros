import 'package:flutter/material.dart';
import 'package:flutter_carros/screens/login_screen.dart';

void main() => runApp(CarApp());

class CarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
//        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoginScreen(),
    );
  }
}
