import 'dart:convert' as convert show json;

import 'entity.dart';

class Car extends Entity {
  int id;
  String name;
  String type;
  String description;
  String urlImage;
  String urlVideo;
  String latitude;
  String longitude;

  Car(
      {this.id,
      this.name,
      this.type,
      this.description,
      this.urlImage,
      this.urlVideo,
      this.latitude,
      this.longitude});

  Car.fromMap(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: json['nome'],
          type: json['tipo'],
          description: json['descricao'],
          urlImage: json['urlFoto'],
          urlVideo: json['urlVideo'],
          latitude: json['latitude'],
          longitude: json['longitude'],
        );

  @override
  Map<String, dynamic> toMap() {
    final json = Map<String, dynamic>();
    json['id'] = this.id;
    json['nome'] = this.name;
    json['tipo'] = this.type;
    json['descricao'] = this.description;
    json['urlFoto'] = this.urlImage;
    json['urlVideo'] = this.urlVideo;
    json['latitude'] = this.latitude;
    json['longitude'] = this.longitude;
    return json;
  }

  String toJson() => convert.json.encode(toMap());
}
