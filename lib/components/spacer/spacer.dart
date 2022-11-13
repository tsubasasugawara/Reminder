import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Spacer extends StatelessWidget {
  double top = 0;
  double bottom = 0;
  double right = 0;
  double left = 0;

  Spacer(this.top, this.bottom, this.right, this.left, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(top: top, bottom: bottom, right: right, left: left),
    );
  }
}
