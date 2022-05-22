import 'package:flutter/material.dart';
import 'package:reminder/components/brightness/brightness.dart';

class ShowSnackBar {
  ShowSnackBar(BuildContext context, String text, Color backgroundColor) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: judgeBlackWhite(backgroundColor),
          ),
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
    );
  }
}
