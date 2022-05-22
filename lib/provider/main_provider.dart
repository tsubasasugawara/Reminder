import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/view/home/deletion_confirmation_dialog.dart';
import 'package:reminder/view/home/home_list.dart';
import 'package:reminder/view/setting/setting.view.dart';

class MainProvider extends ChangeNotifier {
  final int mainPageIndex = 0;
  final int settingPageIndex = 1;

  int index = 0;

  bool isMainPage(
    BuildContext context, {
    bool? val,
  }) {
    if (val == null) {
      return Provider.of<HomeProvider>(context).selectedMode &&
          index == mainPageIndex;
    } else {
      return val && index == mainPageIndex;
    }
  }

  void changeIndex(int _index) {
    index = _index;
    notifyListeners();
  }

  Widget setWidget() {
    switch (index) {
      case 0:
        return const HomeList();
      case 1:
        return const SettingView();
      default:
        return const HomeList();
    }
  }

  Future<void> deleteButton(
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
      await homeProvider.deleteButton(context, homeProvider.model.dataList);
      homeProvider.allSelect(false);
    }
    homeProvider.update();
  }
}
