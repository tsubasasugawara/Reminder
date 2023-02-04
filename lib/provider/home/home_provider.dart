import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/model/db/notifications.dart';
import 'package:reminder/model/home/home_list_model.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/selection_item_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';
import 'package:reminder/view/home/confirmation_dialog.dart';

import '../../model/db/db.dart';

final homeProvider =
    StateNotifierProvider<HomeProvider, Home>((ref) => HomeProvider(false));

class Home {
  // データベースから取得したデータを格納
  List<Map> dataList = <Map>[];

  //完全削除
  static const int completeDeletion = 0;

  //ごみ箱へ
  static const int moveToTrash = 1;

  //復元
  static const int restoreFromTrash = 2;

  //ごみ箱(true)かホーム(false)
  bool isTrash;

  //ソートに使用するカラム
  String orderBy = Notifications.createdAtKey;

  //昇順、降順の設定
  String sortBy = DB.asc;

  bool topup = false;

  //アイテムが選択されているかどうかを格納
  List<bool> selectedItems = [];

  //true: アイテムを選択できる, false: 通常
  bool selectionMode = false;

  //選択したアイテムの数
  int selectedItemsCnt = 0;

  //ソート条件をつけないときに取得するカラム
  final List<Object?> stdColumns = [
    Notifications.idKey,
    Notifications.titleKey,
    Notifications.contentKey,
    Notifications.timeKey,
    Notifications.setAlarmKey,
    Notifications.frequencyKey,
  ];

  Home({
    List<Map>? dataList,
    required this.isTrash,
    this.orderBy = Notifications.createdAtKey,
    this.sortBy = DB.asc,
    this.topup = false,
    this.selectedItems = const [],
    this.selectionMode = false,
    this.selectedItemsCnt = 0,
  }) {
    this.dataList = dataList ?? <Map>[];
    if (selectedItems.isEmpty && this.dataList.isNotEmpty) {
      selectedItems = List.filled(
        this.dataList.length,
        false,
      );
    }
  }

  Home copyWith({
    List<Map>? dataList,
    bool? isTrash,
    String? orderBy,
    String? sortBy,
    bool? topup,
    List<bool>? selectedItems,
    bool? selectionMode,
    int? selectedItemsCnt,
  }) {
    return Home(
      dataList: dataList ?? this.dataList,
      isTrash: isTrash ?? this.isTrash,
      orderBy: orderBy ?? this.orderBy,
      sortBy: sortBy ?? this.sortBy,
      topup: topup ?? this.topup,
      selectedItems: selectedItems ?? this.selectedItems,
      selectionMode: selectionMode ?? this.selectionMode,
      selectedItemsCnt: selectedItemsCnt ?? this.selectedItemsCnt,
    );
  }
}

class HomeProvider extends StateNotifier<Home> {
  HomeProvider(bool isTrash) : super(Home(isTrash: isTrash));

  SelectionItemProvider selectionItemProvider = SelectionItemProvider();

  void setSortBy(String orderBy, String sortBy, bool topup) {
    state.orderBy = orderBy;
    state.sortBy = sortBy;
    state.topup = topup;
  }

  //データ一覧を取得し、modelに保存
  Future<void> setData() async {
    //もしカラムリストに含まれていなかったら追加する
    var columns = [...state.stdColumns];
    if (!state.stdColumns.contains(state.orderBy)) {
      columns = [...columns, state.orderBy];
    }

    List<Map>? dataList = await HomeListModel.select(
      columns,
      where: state.isTrash
          ? '${Notifications.deletedKey} = 1'
          : '${Notifications.deletedKey} = 0',
      orderBy:
          '${state.topup ? '${Notifications.setAlarmKey} ${DB.desc}, ' : ''} ${state.orderBy} ${state.sortBy}',
    );

    state = state.copyWith(
      dataList: dataList,
      selectedItems: List.filled(dataList != null ? dataList.length : 0, false),
      selectedItemsCnt: 0,
      selectionMode: false,
    );
  }

  //すでに発火しているアラームのsetAlarmをオフ(0)にする
  Future<void> update() async {
    var nt = Notifications();
    await nt.update(
      setAlarm: 0,
      where:
          "${Notifications.timeKey} <= ? and ${Notifications.frequencyKey} == 0 and ${Notifications.deletedKey} == 0",
      whereArgs: [DateTime.now().millisecondsSinceEpoch],
    );
    setData();
  }

  /*
   * リマインダー編集画面への遷移
   * @param context:BuildContext
   * @param index:選択されたリマインダーのインデックス
   * @param isTrash : ごみ箱(true)、ホーム(false)
   */
  Future<void> moveToAddView(
    BuildContext context, {
    int? index,
    bool isTrash = false,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          if (index != null) {
            return AddReminderView(
              id: state.dataList[index][Notifications.idKey],
              title: state.dataList[index][Notifications.titleKey],
              content: state.dataList[index][Notifications.contentKey],
              time: state.dataList[index][Notifications.timeKey],
              setAlarm: state.dataList[index][Notifications.setAlarmKey],
              frequency: state.dataList[index][Notifications.frequencyKey],
              isTrash: isTrash,
            );
          }
          return AddReminderView();
        },
      ),
    );
    setData();
  }

  /*
   * 削除確認ダイアログでOKの場合にアラームを削除
   * @param context
   * @param movement : 完全削除(0)かごみ箱(1)か復元(2)
   */
  Future<bool> deleteButton(
    BuildContext context,
    int movement,
  ) async {
    bool res = true;
    if (movement != Home.restoreFromTrash) {
      res = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          movement == Home.completeDeletion
              ? AppLocalizations.of(context)!.deletionConfirmationMsg
              : AppLocalizations.of(context)!.movingToTrashConfirmationMsg,
        ),
      ).then(
        (value) => value ?? false,
      );
    }
    if (!res) return res;

    switch (movement) {
      case Home.completeDeletion: //完全削除
        res = await selectionItemProvider.delete(
          state.dataList,
          state.selectedItems,
        );
        break;
      case Home.moveToTrash: //ごみ箱へ
        res = await selectionItemProvider.trash(
          state.dataList,
          state.selectedItems,
          true,
        );
        break;
      case Home.restoreFromTrash: //ごみ箱から復元
        res = await selectionItemProvider.trash(
          state.dataList,
          state.selectedItems,
          false,
        );
        break;
    }
    update();
    return res;
  }

  void changeMode({required bool selectionMode}) {
    state = state.copyWith(
      selectedItemsCnt: 0,
      selectedItems: List.filled(state.dataList.length, false),
      selectionMode: selectionMode,
    );
  }

  /*
   * アイテムの選択または解除
   * @param index:選択または解除したいアイテムのインデックス
   */
  void changeSelected(int index) {
    var selectedItems = state.selectedItems;
    selectedItems[index] = !selectedItems[index];

    var selectedCnt =
        state.selectedItemsCnt + updateSelectedItemsCnt(selectedItems[index]);

    state = state.copyWith(
      selectedItems: selectedItems,
      selectedItemsCnt: selectedCnt,
      selectionMode: selectedCnt <= 0 ? false : state.selectionMode,
    );
  }

  /*
   * 全てを選択または解除
   * @param select:選択(true)か解除か(false)
   */
  void allSelectOrNot(bool select) {
    int selectedItemsCnt;
    var selectedItems = state.selectedItems;

    if (select && state.selectedItemsCnt < state.selectedItems.length) {
      selectedItemsCnt = state.selectedItems.length;
    } else {
      selectedItemsCnt = 0;
      select = !select;
    }

    for (int i = 0; i < selectedItems.length; i++) {
      selectedItems[i] = select;
    }

    state = state.copyWith(
      selectedItemsCnt: selectedItemsCnt,
      selectedItems: selectedItems,
      selectionMode: select,
    );
  }

  /*
   * selectedItemsの長さを変更
   * @param length:変更後の長さ
   */
  void changeSelectedItemsLen({int? length}) {
    state = state.copyWith(
      selectedItems: List.filled(length ?? state.selectedItems.length, false),
      selectedItemsCnt: 0,
    );
  }

  /*
   * 選択しているアイテムの数を更新
   * @param val:選択(true),解除(false)
   */
  int updateSelectedItemsCnt(bool val) {
    if (val) return 1;
    return -1;
  }
}
