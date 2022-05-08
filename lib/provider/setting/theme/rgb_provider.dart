import 'package:flutter/cupertino.dart';

class RGBProvider extends ChangeNotifier {
  TextEditingController rController = TextEditingController();
  TextEditingController gController = TextEditingController();
  TextEditingController bController = TextEditingController();

  late int _red;
  late int _green;
  late int _blue;

  late int color;

  RGBProvider(Color color) {
    _red = color.red;
    _green = color.green;
    _blue = color.blue;

    rController.text = _red.toString();
    gController.text = _green.toString();
    bController.text = _blue.toString();
  }

  void editRGB({
    int? r,
    int? g,
    int? b,
  }) {
    if (r != null) _red = r;
    if (g != null) _green = g;
    if (b != null) _blue = b;
    notifyListeners();
  }

  Color getColor() {
    return Color.fromARGB(255, _red, _green, _blue);
  }
}
