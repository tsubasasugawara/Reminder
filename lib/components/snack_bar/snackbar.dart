import 'package:flutter/material.dart';

class ShowSnackBar {
  static const successful = Colors.green;
  static const error = Colors.red;

  ShowSnackBar(BuildContext context, String text, Color backgroundColor) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            backgroundColor: backgroundColor,
            content: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              bottom: 50,
              right: 20,
              left: 20,
            ),
          ),
        )
        .closed
        .then(
          (value) => ScaffoldMessenger.of(context).clearSnackBars(),
        );
  }
}
