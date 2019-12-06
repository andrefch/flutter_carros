import 'package:flutter/material.dart';
import 'package:flutter_carros/data/api/car_api.dart';
import 'package:flutter_carros/widgets/car_listview.dart';
import 'package:flutter_carros/widgets/drawer_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Clássicos",
                icon: Icon(Icons.favorite),
              ),
              Tab(
                text: "Esportivos",
                icon: Icon(Icons.star),
              ),
              Tab(
                text: "Luxo",
                icon: Icon(Icons.attach_money),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            CarListView(CarType.classic),
            CarListView(CarType.sport),
            CarListView(CarType.lux),
          ],
        ),
        drawer: DrawerList(),
      ),
    );
  }
}
