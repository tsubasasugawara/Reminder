import 'package:flutter/cupertino.dart';

import '../../../model/db/db_env.dart';

class ReverseOrderButtonProvider extends ChangeNotifier {
  late String sortby;

  ReverseOrderButtonProvider(this.sortby);

  void changeSortBy() {
    sortby = sortby == DBEnv.asc ? DBEnv.desc : DBEnv.asc;
    notifyListeners();
  }
}
