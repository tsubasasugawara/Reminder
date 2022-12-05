import 'package:flutter/material.dart';

class TextFieldCursor {
  /// カーソルを右端に持っていく
  /// * `controller` : 操作を行いたいフォームのコントローラ
  static void moveCursor(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }
}
