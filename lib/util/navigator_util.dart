import 'package:flutter/material.dart';

Future<T> pushScreen<T extends Object>(BuildContext context, Widget screen, {bool replace = false}) {
  final route = MaterialPageRoute<T>(builder: (context) => screen);
  if (replace) {
    return Navigator.pushReplacement(context, route);
  } else {
    return Navigator.push(context, route);
  }
}

void popScreen<T extends Object>(BuildContext context, [T result]) {
  return Navigator.pop(context, result);
}