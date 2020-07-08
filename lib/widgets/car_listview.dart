import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/screens/car_detail_screen.dart';
import 'package:flutter_carros/screens/video_screen.dart';
import 'package:flutter_carros/util/navigator_util.dart';
import 'package:share/share.dart';

class CarListView extends StatelessWidget {
  final List<Car> cars;

  final _random = Random();

  CarListView(this.cars);

  @override
  Widget build(BuildContext context) {
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
          child: InkWell(
            onTap: () => _onItemClicked(context, car),
            onLongPress: () => _onLongPressItemClicked(context, car),
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
                            ? CachedNetworkImage(
                                imageUrl: car.urlImage,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor),
                                    ),
                                  );
                                },
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        'assets/images/placeholder_car.png'),
                              )
                            : Image.asset('assets/images/placeholder_car.png'),
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
                      car.description ?? '',
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
                              'DETALHES',
                            ),
                            onPressed: () =>
                                _onDetailButtonClicked(context, car),
                          ),
                          FlatButton(
                            child: Text(
                              'COMPARTILHAR',
                            ),
                            onPressed: () =>
                                _onShareButtonClicked(context, car),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onDetailButtonClicked(BuildContext context, Car car) {
    _openCarDetailScreen(context, car);
  }

  void _onShareButtonClicked(BuildContext context, Car car) {
    _shareCar(context, car);
  }

  void _onItemClicked(BuildContext context, Car car) {
    _openCarDetailScreen(context, car);
  }

  void _onLongPressItemClicked(BuildContext context, Car car) {
    if (_random.nextBool()) {
      _showCardOptions(context, car);
    } else {
      _showCardOptionsBottomSheet(context, car);
    }
  }

  void _openCarDetailScreen(BuildContext context, Car car) {
    pushScreen(context, CarDetailScreen(car));
  }

  void _playVideo(BuildContext context, Car car) {
    pushScreen(context, VideoScreen(car: car));
  }

  void _shareCar(BuildContext context, Car car) {
    Share.share(car.urlImage, subject: car.name);
  }

  void _showCardOptions(BuildContext context, Car car) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(car.name),
        children: _createCardOptions(context, car),
      ),
    );
  }

  void _showCardOptionsBottomSheet(BuildContext context, Car car) {
    List<Widget> items = _createCardOptions(context, car);
    items.insert(
        0,
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Text(
            car.name,
            style: Theme.of(context).textTheme.headline6,
          ),
        ));

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => ListView(
        shrinkWrap: true,
        children: items,
      ),
    );
  }

  List<Widget> _createCardOptions(BuildContext context, Car car) {
    return <Widget>[
      ListTile(
        title: Text('Detalhes'),
        leading: Icon(
          Icons.directions_car,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () {
          popScreen(context);
          _openCarDetailScreen(context, car);
        },
      ),
      ListTile(
        title: Text('Compartilhar'),
        leading: Icon(
          Icons.share,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () {
          popScreen(context);
          _shareCar(context, car);
        },
      ),
      ListTile(
        title: Text('Assistir vídeo'),
        leading: Icon(
          Icons.video_library,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () {
          popScreen(context);
          _playVideo(context, car);
        },
      ),
    ];
  }
}
