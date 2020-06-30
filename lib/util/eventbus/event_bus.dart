import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'event/event.dart';

class EventBus {
  static EventBus get(BuildContext context) => Provider.of<EventBus>(
        context,
        listen: false,
      );

  final _streamController = StreamController<Event>.broadcast();

  Stream<Event> get stream => _streamController.stream;

  void sendEvent(Event event) {
    _streamController.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}
