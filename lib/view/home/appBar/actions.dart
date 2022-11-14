import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/view/home/appBar/reverse_button.dart';
import 'package:reminder/view/home/appBar/top_up_set_alarm_button.dart';

import '../../../components/snack_bar/snackbar.dart';
import '../../../model/db/db.dart';
import '../../../provider/home/home_provider.dart';

class Actions {
  late HomeProvider provider;
  late BuildContext context;

  Actions(this.provider, this.context);

  /// ソート方法選択ボタンの生成
  /// * `dbKey` : ソートに使うカラムのキー
  /// * `text` : ボタンに表示するテキスト
  /// @{return} ソート方法選択ボタン
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

  /// アイテムを選択するモードのときのactions
  /// @{return} List<Widget>
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
                  context, HomeProvider.moveToTrash);
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
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1,
                      thickness: 1,
                    ),
                    _makeButton(
                      Notifications.idKey,
                      AppLocalizations.of(context)!.orderById,
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1,
                      thickness: 1,
                    ),
                    _makeButton(
                      Notifications.titleKey,
                      AppLocalizations.of(context)!.orderByTitle,
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1,
                      thickness: 1,
                    ),
                    _makeButton(
                      Notifications.createdAtKey,
                      AppLocalizations.of(context)!.orderByCreatedAt,
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1,
                      thickness: 1,
                    ),
                    _makeButton(
                      Notifications.updatedAtKey,
                      AppLocalizations.of(context)!.orderByUpdatedAt,
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1,
                      thickness: 1,
                    ),
                    _makeButton(
                      Notifications.timeKey,
                      AppLocalizations.of(context)!.orderByAlarmTime,
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1,
                      thickness: 1,
                    ),
                    ReverseOrderButton(
                      () {
                        provider.changeSortBy();
                      },
                      provider.sortBy,
                    ),
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

  /// actionsの生成
  /// @{return} List<Widget>
  List<Widget> build() {
    return provider.selectionMode ? _selectionMode() : normalMode();
  }
}