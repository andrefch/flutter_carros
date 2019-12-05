import 'package:flutter/material.dart';
import 'package:flutter_carros/data/api/car_api.dart';
import 'package:flutter_carros/data/model/car.dart';
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
    final cars = CarApi.getCars();
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (BuildContext context, int index) {
        final Car car = cars[index];
        return Row(
          children: <Widget>[
            Image.network(
              car.urlImage,
              width: 180,
            ),
            Flexible(
              child: Text(
                car.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 22),
              ),
            )
          ],
        );
      },
    );
  }
}
