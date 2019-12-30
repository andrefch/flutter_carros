import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_carros/bloc/car_bloc.dart';
import 'package:flutter_carros/data/api/car_api.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/screens/car_detail_screen.dart';
import 'package:flutter_carros/util/navigator_util.dart';

class CarListView extends StatefulWidget {
  final CarType carType;

  CarListView(this.carType);

  @override
  _CarListViewState createState() => _CarListViewState();
}

class _CarListViewState extends State<CarListView>
    with AutomaticKeepAliveClientMixin<CarListView> {
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
          currentWidget =  Center(
            child: Text(
              "Failed to load data.\n${snapshot.error}".trim(),
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data;
          if (data.isNotEmpty) {
            currentWidget = _createListView(data);
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

  ListView _createListView(List<Car> cars) {
    return ListView.builder(
      itemCount: cars?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final Car car = cars[index];
        return Container(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: index == 0 ? 12 : 2,
            bottom: index == cars.length - 1 ? 12 : 2,
          ),
          child: Card(
            color: Colors.grey[200],
            child: Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      width: 250,
                      height: 105,
                      child: car.urlImage != null
                          ? Image.network(car.urlImage)
                          : Image.asset("assets/images/placeholder_car.png"),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    car.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 22),
                  ),
                  Text(
                    car.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  ButtonBarTheme(
                    data: ButtonBarTheme.of(context),
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            "DETALHES",
                          ),
                          onPressed: () => _onDetailButtonClicked(car),
                        ),
                        FlatButton(
                          child: Text(
                            "COMPARTILHAR",
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onDetailButtonClicked(Car car) {
    pushScreen(context, CarDetailScreen(car));
  }
}
