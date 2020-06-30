import 'package:flutter_carros/data/api/car_api.dart';
import 'package:flutter_carros/util/eventbus/event/event.dart';

class CarEvent extends Event<CarEventAction> {

  CarEventAction _action;
  final CarType carType;

  CarEvent({CarEventAction action, this.carType}) {
    _action = action;
  }

  @override
  CarEventAction get action => _action;
}

enum CarEventAction {
  SAVED, DELETED
}
