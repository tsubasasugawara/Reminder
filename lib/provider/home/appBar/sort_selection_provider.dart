import 'package:flutter/material.dart';

import '../../../model/db/db.dart';

class SortSelectionProvider extends ChangeNotifier {
  late String orderBy;
  late String sortBy;
  late bool topup;

  SortSelectionProvider(this.orderBy, this.sortBy, this.topup);

  void setOrderBy(String orderBy) {
    this.orderBy = orderBy;
    notifyListeners();
  }

  bool equalsOrderBy(String str) {
    if (orderBy == str) return true;
    return false;
  }

  void changeSortBy() {
    sortBy = sortBy == DB.asc ? DB.desc : DB.asc;
    notifyListeners();
  }

  void changeTopUp() {
    topup = !topup;
    notifyListeners();
  }
}
