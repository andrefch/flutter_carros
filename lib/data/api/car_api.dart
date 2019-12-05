import 'package:flutter_carros/data/model/car.dart';

class CarApi {
  CarApi._();

  static List<Car> getCars() {
    List<Car> result = List<Car>();
    result.add(Car(name: "Chevrolet Corvette", urlImage: "http://www.livroandroid.com.br/livro/carros/classicos/Chevrolet_Corvette.png"));
    result.add(Car(name: "Chevrolet Impala Coupe", urlImage: "http://www.livroandroid.com.br/livro/carros/classicos/Chevrolet_Impala_Coupe.png"));
    result.add(Car(name: "Cadillac Deville Convertible", urlImage: "http://www.livroandroid.com.br/livro/carros/classicos/Cadillac_Deville_Convertible.png"));
    return result;
  }
}