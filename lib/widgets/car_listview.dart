import 'package:flutter/material.dart';
import 'package:flutter_carros/data/api/car_api.dart';
import 'package:flutter_carros/data/model/car.dart';

class CarListView extends StatefulWidget {
  final CarType carType;

  CarListView(this.carType);

  @override
  _CarListViewState createState() => _CarListViewState();
}

class _CarListViewState extends State<CarListView>
    with AutomaticKeepAliveClientMixin<CarListView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: CarApi.getCars(this.widget.carType),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _createListView(snapshot.data);
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
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
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            "DETALHES",
                          ),
                          onPressed: () {},
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
}
