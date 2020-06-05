import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/screens/car_detail_screen.dart';
import 'package:flutter_carros/util/navigator_util.dart';

class CarListView extends StatelessWidget {
  final List<Car> cars;

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
                              errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/placeholder_car.png"),
                            )
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
                          onPressed: () => _onDetailButtonClicked(context, car),
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

  void _onDetailButtonClicked(BuildContext context, Car car) {
    pushScreen(context, CarDetailScreen(car));
  }
}
