import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reminder/model/kotlin_method_calling/kotlin_method_calling.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/view/home/appBar/reverse_button.dart';
import 'package:reminder/view/home/appBar/top_up_set_alarm_button.dart';

import '../../../components/snack_bar/snackbar.dart';
import '../../../model/db/notifications.dart';
import '../../../provider/home/home_provider.dart';
import '../../search/search_view.dart';

class Actions {
  late HomeProvider provider;
  late BuildContext context;

  Actions(this.provider, this.context);

  /*
   * デバッグ専用のリマインダーを追加するボタン
   * @return Widget:デバッグモードであれば、ボタンが見える
   */
  Widget _addReminderForDebugging() {
    return Visibility(
      visible: kDebugMode,
      child: IconButton(
        icon: const Icon(Icons.developer_mode),
        onPressed: () async {
          var title = "Test";
          var content = "Test Test Test Test Test Test";
          var frequency = 0;
          var time = DateTime.now()
              .add(const Duration(seconds: 5))
              .millisecondsSinceEpoch;
          var onOff = Notifications.alarmOn;
          var homeOrTrash = Notifications.inHome;

          var notifications = Notifications();
          var res = await notifications.insert(
            title,
            content,
            frequency,
            time,
            onOff,
            homeOrTrash,
          );
          if (res == null) return;

          await KotlinMethodCalling.registAlarm(
              res, title, content, time, frequency);
        },
      ),
    );
  }

  /*
   * ソート方法選択ボタンの生成
   * @param dbKey : ソートに使うカラムのキー
   * @param text : ボタンに表示するテキスト
   * @return Widget : ソート方法選択ボタン
   */
  Widget _makeButton(
    String dbKey,
    String text,
  ) {
    return TextButton(
      onPressed: () async {
        provider.setOrderBy(dbKey);
        await provider.setData();
        Navigator.pop(context);
      },
      style: TextButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: (dbKey == provider.orderBy)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  color: Theme.of(context).primaryColor,
                  size: 15,
                ),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1?.apply(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            )
          : Text(
              text,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }

  /*
   * 水平線を作成
   * @return Widget : Divider
   */
  Widget _makeDivider() {
    return Divider(
      color: Theme.of(context).dividerColor,
      height: 1,
      thickness: 1,
    );
  }

  /*
   * アイテムを選択するモードのときのactions
   * @return List<Widget>
   */
  List<Widget> _selectionMode() {
    return [
      Row(
        children: [
          IconButton(
            onPressed: () {
              provider.allSelectOrNot(true);
            },
            icon: const Icon(Icons.select_all),
          ),
          IconButton(
            onPressed: () async {
              var res = await provider.deleteButton(
                context,
                HomeProvider.moveToTrash,
              );
              if (res) {
                ShowSnackBar(
                  context,
                  AppLocalizations.of(context)!.moveReminderToTrash,
                  Theme.of(context).primaryColor,
                );
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    ];
  }

  List<Widget> normalMode() {
    return [
      _addReminderForDebugging(),
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SearchView(
                provider.model.dataList,
                provider.isTrash,
              ),
            ),
          );
          await provider.setData();
        },
      ),
      IconButton(
        tooltip: AppLocalizations.of(context)!.order,
        iconSize: 30,
        icon: const Icon(Icons.sort),
        onPressed: () async {
          await showDialog(
            builder: (BuildContext context) {
              return Dialog(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        AppLocalizations.of(context)!.orderMethod,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    _makeDivider(),
                    _makeButton(
                      Notifications.createdAtKey,
                      AppLocalizations.of(context)!.orderByCreatedAt,
                    ),
                    _makeDivider(),
                    _makeButton(
                      Notifications.updatedAtKey,
                      AppLocalizations.of(context)!.orderByUpdatedAt,
                    ),
                    _makeDivider(),
                    _makeButton(
                      Notifications.timeKey,
                      AppLocalizations.of(context)!.orderByAlarmTime,
                    ),
                    _makeDivider(),
                    _makeButton(
                      Notifications.titleKey,
                      AppLocalizations.of(context)!.orderByTitle,
                    ),
                    _makeDivider(),
                    ReverseOrderButton(
                      () {
                        provider.changeSortBy();
                      },
                      provider.sortBy,
                    ),
                    _makeDivider(),
                    TopUpSetAlarmButton(
                      () {
                        provider.changeTopUpSetAlarmReminder();
                      },
                      provider.topUpSetAlarmReminder,
                    ),
                  ],
                ),
              );
            },
            context: context,
          );
        },
      ),
    ];
  }

  /*
   * actionsの生成
   * @return List<Widget>
   */
  List<Widget> build() {
    return provider.selectionMode ? _selectionMode() : normalMode();
  }
}
