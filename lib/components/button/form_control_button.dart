import 'package:flutter/material.dart';

class FormControlButton extends StatelessWidget {
  final IconData iconData;
  final Color buttonColor;
  final String buttonText;
  final Function() action;

  const FormControlButton(
      this.iconData, this.buttonColor, this.buttonText, this.action,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(
        iconData,
        color: Colors.black,
      ),
      label: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      onPressed: () {
        action();
      },
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
