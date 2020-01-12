import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_carros/bloc/car_bloc.dart';
import 'package:flutter_carros/data/api/car_api.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/widgets/car_listview.dart';

class CarPage extends StatefulWidget {
  final CarType carType;

  CarPage(this.carType);

  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage>
    with AutomaticKeepAliveClientMixin<CarPage> {
  final CarBloc _carBloc = CarBloc();

  @override
  void initState() {
    super.initState();
    _carBloc.fetch(widget.carType);
  }

  @override
  void dispose() {
    _carBloc.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Car>>(
      stream: _carBloc.stream,
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
              "Failed to load data.",
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
              child: Text("No data :("),
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
    return _carBloc.fetch(widget.carType);
  }
}
