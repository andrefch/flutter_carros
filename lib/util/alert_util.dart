import 'package:flutter/material.dart';
import 'package:flutter_carros/util/navigator_util.dart';

showAlert(
    {BuildContext context,
    String title,
    String message,
    VoidCallback callback}) {
  showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  popScreen(context);
                  callback?.call();
                },
              )
            ],
          ),
        );
      });
}
