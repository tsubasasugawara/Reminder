import 'package:flutter/cupertino.dart';

class DeletionProvider extends ChangeNotifier {
  bool _autoDeletion = false;
  bool _notAutoDeletion = true;

  FocusNode dayToDeleteFocusNode = FocusNode();

  bool getNotAutoDeletionState() {
    return _notAutoDeletion;
  }

  bool getAutoDeletionState() {
    return _autoDeletion;
  }

  void changeAutoDeletionValue(bool state) {
    _autoDeletion = state;
    notifyListeners();
  }

  void changeNotAutoDeletionValue(bool state) {
    _notAutoDeletion = state;
    notifyListeners();
  }
}
