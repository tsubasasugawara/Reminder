import 'package:flutter/material.dart';
import 'package:reminder/values/colors.dart';

class AddReminderTextForm extends StatelessWidget {
  final TextEditingController controller;
  final double textSize;
  final Function(String) changedAction;
  final int? minLines;
  final int? maxLines;
  final String hintText;

  const AddReminderTextForm(this.controller, this.textSize, this.changedAction,
      this.minLines, this.maxLines, this.hintText,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: AppColors.textColor,
        fontSize: textSize,
      ),
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: textSize,
        ),
        contentPadding: const EdgeInsets.all(10),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
      onChanged: (text) {
        changedAction(text);
      },
    );
  }
}
