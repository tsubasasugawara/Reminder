import 'package:flutter/material.dart';
import 'package:reminder/values/colors.dart';

class ShowSnackBar {
  static const successful = AppColors.mainColor;
  static const error = AppColors.error;

  ShowSnackBar(BuildContext context, String text, Color backgroundColor) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
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
    );
  }
}
