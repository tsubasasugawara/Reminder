import 'package:flutter/material.dart';

class FormControlButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final Function() action;
  // ignore: use_key_in_widget_constructors
  const FormControlButton(this.buttonText, this.textColor, this.action);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        action();
      },
      child: Text(
        buttonText,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
