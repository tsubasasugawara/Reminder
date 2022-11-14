import 'package:flutter/cupertino.dart';
import 'package:reminder/model/db/db.dart';

class ReverseOrderButtonProvider extends ChangeNotifier {
  late String sortby;

  ReverseOrderButtonProvider(this.sortby);

  void changeSortBy() {
    sortby =
        sortby == Notifications.asc ? Notifications.desc : Notifications.asc;
    notifyListeners();
  }
}
