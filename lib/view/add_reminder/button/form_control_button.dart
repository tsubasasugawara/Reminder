import 'package:flutter/material.dart';
import 'package:reminder/values/colors.dart';

class FormControlButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final Function() action;
  // ignore: use_key_in_widget_constructors
  const FormControlButton(this.buttonText, this.textColor, this.action);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        action();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.backgroundColor),
      ),
      child: Text(
        buttonText,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
