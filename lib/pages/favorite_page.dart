import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/model/favorite_model.dart';
import 'package:flutter_carros/widgets/car_listview.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin<FavoritePage> {
  @override
  void initState() {
    super.initState();
    _updateFavoriteModel();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<Car> data = Provider.of<FavoriteModel>(context).cars;
    Widget currentWidget;
    if (data.isNotEmpty) {
      currentWidget = CarListView(data);
    } else {
      currentWidget = Center(
        child: Text(
          "No favorites yet :(",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: currentWidget,
    );
  }

  Future<void> _onRefresh() async {
    return _updateFavoriteModel();
  }

  void _updateFavoriteModel() {
    Provider.of<FavoriteModel>(context, listen: false).fetchCars();
  }
}
