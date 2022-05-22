import 'package:flutter/material.dart';
import 'package:reminder/components/snack_bar/snackbar.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/kotlin_method_calling/kotlin_method_calling.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class SelectionItemProvider {
  List<bool> selectedItems = [];
  bool selectedMode = false;
  int selectedItemsCnt = 0;

  Future<bool> _deleteData(List<int> ids) async {
    var res = await NotificationsTable().multipleDelete(ids);
    if (res != null && res >= 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _deleteAlarm(
    int id,
    String title,
    String content,
    int time,
  ) async {
    await KotlinMethodCalling.deleteAlarm(id, title, content, time);
  }

  List<int> getSelectedIndex() {
    List<int> indexs = [];
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) indexs.add(i);
    }
    return indexs;
  }

  Future<void> deleteButton(
    BuildContext context,
    List<Map<dynamic, dynamic>> dataList, {
    Function()? action,
  }) async {
    List<int> ids = [];
    for (var ele in getSelectedIndex()) {
      var data = dataList[ele];
      ids.add(data['id']);
      await _deleteAlarm(
          data['id'], data['title'], data['content'], data['time']);
    }
    var res = await _deleteData(ids);

    if (res) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.deletedAlarm,
        Theme.of(context).primaryColor,
      );
    }

    if (action != null) action();
  }

  void changeSelectedItemsLen({int? length}) {
    selectedItems = List.filled(length ?? selectedItems.length, false);
  }

  void changeSelected(int index) {
    selectedItems[index] = !selectedItems[index];
    updateSelectedItemsCnt(selectedItems[index]);
    updateOrChangeMode();
  }

  void allSelect(bool select) {
    if (select && selectedItemsCnt < selectedItems.length) {
      selectedItemsCnt = selectedItems.length;
    } else {
      selectedItemsCnt = 0;
    }
    for (int i = 0; i < selectedItems.length; i++) {
      selectedItems[i] = select;
    }
    updateOrChangeMode();
  }

  void updateOrChangeMode() {}

  void updateSelectedItemsCnt(bool val) {
    if (val) {
      selectedItemsCnt++;
    } else {
      selectedItemsCnt--;
    }
  }

  void changeMode(bool mode) {}
}
