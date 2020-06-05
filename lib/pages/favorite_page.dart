import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_carros/bloc/favorite_bloc.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/widgets/car_listview.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin<FavoritePage> {
  final FavoriteBloc _favoriteBloc = FavoriteBloc();

  @override
  void initState() {
    super.initState();
    _favoriteBloc.fetchCars();
  }

  @override
  void dispose() {
    _favoriteBloc.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Car>>(
      stream: _favoriteBloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasError && !snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        Widget currentWidget;

        if (snapshot.hasError) {
          currentWidget = Center(
            child: Text(
              "Failed to load favorite cars.",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data;
          if (data.isNotEmpty) {
            currentWidget = CarListView(data);
          } else {
            currentWidget = Center(
              child: Text("No favorites yet :("),
            );
          }
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: currentWidget,
        );
      },
    );
  }

  Future<void> _onRefresh() {
    return _favoriteBloc.fetchCars();
  }
}
