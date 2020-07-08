import 'dart:async';

import 'package:flutter_carros/data/api/lorem_ipsum_api.dart';

class LoremIpsumBloc {

  final StreamController<String> _streamController = StreamController<String>();

  Stream<String> get stream => _streamController.stream;

  void fetch() async {
    final lorem = await LoremIpsumApi.getLoremIpsum();
    if (!_streamController.isClosed) {
      _streamController.add(lorem);
    }
  }

  void dispose() {
    _streamController.close();
  }
}