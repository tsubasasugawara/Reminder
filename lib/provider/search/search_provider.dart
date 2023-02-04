import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/db/notifications.dart';
import '../home/home_provider.dart';

final searchProvider =
    StateNotifierProvider<SearchProvider, SearchProviderData>(
        (ref) => SearchProvider(
              ref.read(homeProvider).dataList,
              ref.read(homeProvider).isTrash,
            ));

class SearchProviderData {
  bool isTrash = false;

  // データベースのデータを格納
  List<Map> dataList = <Map>[];
  List<Map> displayDataList = <Map>[];

  // 検索バーのcontrollerとfocusNode
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  // キーボードが表示されているかどうか
  bool isKeyboardShown = false;

  SearchProviderData({
    required this.dataList,
    required this.isTrash,
    List<Map>? displayDataList,
    TextEditingController? controller,
    FocusNode? focusNode,
    this.isKeyboardShown = false,
  }) {
    this.displayDataList = displayDataList ?? <Map>[];
    this.controller = controller ?? TextEditingController();
    this.focusNode = focusNode ?? FocusNode();
  }

  SearchProviderData copyWith({
    List<Map>? dataList,
    List<Map>? displayDataList,
    TextEditingController? controller,
    FocusNode? focusNode,
    bool? isKeyboardShown,
  }) {
    return SearchProviderData(
      dataList: dataList ?? this.dataList,
      isTrash: isTrash,
      displayDataList: displayDataList ?? this.displayDataList,
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
      isKeyboardShown: isKeyboardShown ?? this.isKeyboardShown,
    );
  }
}

class SearchProvider extends StateNotifier<SearchProviderData> {
  SearchProvider(List<Map> dataList, bool isTrash)
      : super(SearchProviderData(dataList: dataList, isTrash: isTrash));

  // TODO: 連続で文字を入力しているときに、調べ直すのではなく、すでに一文字目を調べたものから探す
  void search(String str) {
    var displayDataList = <Map>[];
    if (str.isEmpty) {
      state = state.copyWith(displayDataList: displayDataList);
      return;
    }

    str = str.toLowerCase();

    for (int i = 0; i < state.dataList.length; i++) {
      if (state.dataList[i][Notifications.titleKey]
          .toLowerCase()
          .contains(str)) {
        displayDataList.add(state.dataList[i]);
      }
    }

    state = state.copyWith(displayDataList: displayDataList);
  }
}
