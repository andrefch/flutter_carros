import 'package:flutter/material.dart';
import 'package:flutter_carros/widgets/drawer_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: _createBody(),
      drawer: DrawerList(),
    );
  }

  Widget _createBody() {
    return Center(
      child: Text(
        "André",
        style: TextStyle(
          fontSize: 22,
        ),
      ),
    );
  }
}
