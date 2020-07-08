import 'package:flutter/material.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:flutter_carros/service/favorite_service.dart';
import 'package:flutter_carros/widgets/car_listview.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin<FavoritePage> {

  final _favoriteService = FavoriteService();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<Car>>(
      stream: _favoriteService.favoriteCars,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
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
            return CarListView(data);
          } else {
            return Center(
              child: Text("No favorites yet :("),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
