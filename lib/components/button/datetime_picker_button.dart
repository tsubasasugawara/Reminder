import 'package:flutter/material.dart';

class DateTimePickerButton extends StatelessWidget {
  final Future Function() pressedAction;
  final String text;

  const DateTimePickerButton(this.text, this.pressedAction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        pressedAction();
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
        ),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            side: BorderSide(color: Colors.green, width: 1),
          ),
        ),
      ),
    );
  }
}
