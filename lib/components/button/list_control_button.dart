import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListControlButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function() action;

  const ListControlButton(this.text, this.color, this.action, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        action();
      },
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(
          color: color,
          width: 1,
        ),
      ),
    );
  }
}
