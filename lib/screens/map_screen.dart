import 'package:flutter/material.dart';
import 'package:flutter_carros/data/model/car.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final Car car;

  MapScreen({this.car});

  double get _latitude {
    try {
      return double.parse(car.latitude);
    } on FormatException catch (e) {
      print(e);
      return 0;
    }
  }

  double get _longitude {
    try {
      return double.parse(car.longitude);
    } on FormatException catch (e) {
      print(e);
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng latLng = _createLatLng();

    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: latLng,
          zoom: 17,
        ),
        markers: {
          _createMarker(context, latLng),
        },
      ),
    );
  }

  LatLng _createLatLng() =>  LatLng(_latitude, _longitude);

  Marker _createMarker(BuildContext context, LatLng position) {
    return Marker(
      markerId: MarkerId(car.id.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: car.name,
        snippet: 'Local de fabricação',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        HSLColor.fromColor(Theme.of(context).primaryColor).hue,
      )
    );
  }
}
