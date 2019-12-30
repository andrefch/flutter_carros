import 'package:flutter/cupertino.dart';

Text text(String value, {Color color, double size = 16.0, bool bold = false, bool italic = false, TextAlign textAlign = TextAlign.start}) {
  return Text(
    value,
    textAlign: textAlign,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    ),
  );
}
