import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/db/db.dart';

// TODO:ソートの動作確認
class SortSelection {
  late String orderBy;
  late String sortBy;
  late bool topup;

  SortSelection({
    required this.orderBy,
    required this.sortBy,
    required this.topup,
  });

  SortSelection copyWith({
    String? orderBy,
    String? sortBy,
    bool? topup,
  }) {
    return SortSelection(
      orderBy: orderBy ?? this.orderBy,
      sortBy: sortBy ?? this.sortBy,
      topup: topup ?? this.topup,
    );
  }
}

class SortSelectionProvider extends StateNotifier<SortSelection> {
  SortSelectionProvider(
    String orderBy,
    String sortBy,
    bool topup,
  ) : super(SortSelection(orderBy: orderBy, sortBy: sortBy, topup: topup));

  void setOrderBy(String orderBy) {
    state = state.copyWith(orderBy: orderBy);
  }

  bool equalsOrderBy(String str) {
    if (state.orderBy == str) return true;
    return false;
  }

  void changeSortBy() {
    state = state.copyWith(sortBy: state.sortBy == DB.asc ? DB.desc : DB.asc);
  }

  void changeTopUp() {
    state = state.copyWith(topup: !state.topup);
  }
}
