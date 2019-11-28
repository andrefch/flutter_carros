import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool showProgress;

  AppButton(
      {@required this.text,
      @required this.onPressed,
      this.showProgress = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: this.showProgress
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              )
            : Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
        onPressed: onPressed,
      ),
    );
  }
}
