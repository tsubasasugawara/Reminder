import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/view/home/deletion_confirmation_dialog.dart';
import 'package:reminder/view/home/home_list.dart';
import 'package:reminder/view/setting/setting.view.dart';

class MainProvider extends ChangeNotifier {
  final int homeIndex = 0;
  final int settingPageIndex = 1;

  /// 現在のページの番号
  int index = 0;

  /// ホームにいる場合はtrue、それ以外はfalse
  /// * `context`
  bool isHome(BuildContext context) {
    return Provider.of<HomeProvider>(context).selectionMode &&
        index == homeIndex;
  }

  /// ページを変更する
  /// * `_index`:遷移先のページ番号
  void changeIndex(int _index) {
    index = _index;
    notifyListeners();
  }

  /// 現在のインデックスのページを返す
  Widget setWidget() {
    switch (index) {
      case 1:
        return const SettingView();
      default:
        return const HomeList();
    }
  }

  /// 削除確認ダイアログでOKの場合にアラームを削除
  /// * `context`
  /// * `homeProvider`
  Future<bool> deleteButton(
    BuildContext context,
    HomeProvider homeProvider,
  ) async {
    var res = await showDialog(
      context: context,
      builder: (context) => const DeletionConfirmationDialog(),
    ).then(
      (value) => value ?? false,
    );
    if (res) {
      res =
          await homeProvider.deleteButton(context, homeProvider.model.dataList);
      homeProvider.update();
      homeProvider.allSelectOrNot(false);
    }
    return res;
  }
}
