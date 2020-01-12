import 'package:flutter/material.dart';
import 'package:flutter_carros/constants.dart';
import 'package:flutter_carros/data/api/car_api.dart';
import 'package:flutter_carros/util/prefs.dart';
import 'package:flutter_carros/widgets/car_page.dart';
import 'package:flutter_carros/widgets/drawer_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin<HomeScreen> {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        bottom: TabBar(
          controller: _tabController,
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
        controller: _tabController,
        children: <Widget>[
          CarPage(CarType.classic),
          CarPage(CarType.sport),
          CarPage(CarType.lux),
        ],
      ),
      drawer: DrawerList(),
    );
  }

  void _initializeTabController() async {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_updateSelectedTab);
    _tabController.index = await Preferences.getInt(Constants.KEY_SELECTED_TAB);
  }

  void _updateSelectedTab() {
    Preferences.setInt(Constants.KEY_SELECTED_TAB, _tabController.index);
  }
}
