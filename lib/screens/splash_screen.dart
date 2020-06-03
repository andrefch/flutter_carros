import 'package:flutter/material.dart';
import 'package:flutter_carros/data/local/database_helper.dart';
import 'package:flutter_carros/data/model/user.dart';
import 'package:flutter_carros/screens/home_screen.dart';
import 'package:flutter_carros/screens/login_screen.dart';
import 'package:flutter_carros/util/navigator_util.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    final delay = Future.delayed(Duration(seconds: 3));
    final database = DatabaseHelper.getInstance().database;
    final user = User.load();

    Future.wait([delay, database, user]).then((value) {
      final user = value[2];
      final screen = user != null ? HomeScreen() : LoginScreen();
      _openScreen(screen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200],
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _openScreen(Widget screen) {
    pushScreen(context, screen, replace: true);
  }
}
