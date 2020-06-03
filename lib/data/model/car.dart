import 'entity.dart';

class Car implements Entity {
  final int id;
  final String name;
  final String type;
  final String description;
  final String urlImage;
  final String urlVideo;
  final String latitude;
  final String longitude;

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
}
