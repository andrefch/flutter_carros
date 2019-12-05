import 'dart:ffi';

class Car {
  final int id;
  final String name;
  final String type;
  final String description;
  final String urlImage;
  final String urlVideo;
  final Float latitude;
  final Float longitude;

  Car(
      {this.id,
      this.name,
      this.type,
      this.description,
      this.urlImage,
      this.urlVideo,
      this.latitude,
      this.longitude});

  Car.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"],
          name: json["nome"],
          type: json["tipo"],
          description: json["descricao"],
          urlImage: json["urlFoto"],
          urlVideo: json["urlVideo"],
          latitude: json["latitude"],
          longitude: json["longitude"],
        );
}
