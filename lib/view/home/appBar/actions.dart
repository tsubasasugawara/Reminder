import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/model/platform/kotlin.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/appBar/sort_selection_provider.dart';
import 'package:reminder/utils/complete_and_cancel_button/complete_and_cancel_button.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../model/db/db.dart';
import '../../../utils/snack_bar/snackbar.dart';
import '../../../model/db/notifications.dart';
import '../../../provider/home/home_provider.dart';
import '../../search/search_view.dart';

final sortSelectionProvider =
    StateNotifierProvider<SortSelectionProvider, SortSelection>(
        (ref) => SortSelectionProvider(
              ref.read(homeProvider).orderBy,
              ref.read(homeProvider).sortBy,
              ref.read(homeProvider).topup,
            ));

class Actions {
  late BuildContext context;
  late WidgetRef ref;

  Actions(this.context, this.ref);

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

          await Kotlin.registAlarm(res, title, content, time, frequency);
        },
      ),
    );
  }

  Widget switchDescAscBtn(Function onPressed, String sortby) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      style: TextButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: (DB.desc == sortby)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.sortBy,
                  style: Theme.of(context).textTheme.bodyLarge?.apply(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            )
          : Text(
              AppLocalizations.of(context)!.sortBy,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }

  Widget switchOnAboveBringBtn(Function onPressed, bool topup) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      style: TextButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: (topup)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.topUpSetAlarmReminder,
                  style: Theme.of(context).textTheme.bodyLarge?.apply(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            )
          : Text(
              AppLocalizations.of(context)!.topUpSetAlarmReminder,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }

  /*
   * ソート方法選択ボタンの生成
   * @param dbKey : ソートに使うカラムのキー
   * @param text : ボタンに表示するテキスト
   * @param context : BuildContext
   * @return Widget : ソート方法選択ボタン
   */
  Widget _makeButton(
    String dbKey,
    String text,
    BuildContext context,
  ) {
    return TextButton(
      onPressed: () async {
        context.read(sortSelectionProvider.notifier).setOrderBy(dbKey);
      },
      style: TextButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: (context.read(sortSelectionProvider.notifier).equalsOrderBy(dbKey))
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
                  style: Theme.of(context).textTheme.bodyLarge?.apply(
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
              ref.read(homeProvider.notifier).allSelectOrNot(true);
            },
            icon: const Icon(Icons.select_all),
          ),
          IconButton(
            onPressed: () async {
              var res = await ref.read(homeProvider.notifier).deleteButton(
                    context,
                    Home.moveToTrash,
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
              builder: (context) => const SearchView(),
            ),
          );
          await ref.read(homeProvider.notifier).setData();
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
                child: Consumer(builder: (context, ref, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          AppLocalizations.of(context)!.orderMethod,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      _makeDivider(),
                      _makeButton(
                        Notifications.createdAtKey,
                        AppLocalizations.of(context)!.orderByCreatedAt,
                        context,
                      ),
                      _makeDivider(),
                      _makeButton(
                        Notifications.updatedAtKey,
                        AppLocalizations.of(context)!.orderByUpdatedAt,
                        context,
                      ),
                      _makeDivider(),
                      _makeButton(
                        Notifications.timeKey,
                        AppLocalizations.of(context)!.orderByAlarmTime,
                        context,
                      ),
                      _makeDivider(),
                      _makeButton(
                        Notifications.titleKey,
                        AppLocalizations.of(context)!.orderByTitle,
                        context,
                      ),
                      _makeDivider(),
                      switchDescAscBtn(
                        () {
                          ref
                              .read(sortSelectionProvider.notifier)
                              .changeSortBy();
                        },
                        ref.watch(sortSelectionProvider).sortBy,
                      ),
                      _makeDivider(),
                      switchOnAboveBringBtn(
                        () {
                          ref
                              .read(sortSelectionProvider.notifier)
                              .changeTopUp();
                        },
                        ref.watch(sortSelectionProvider).topup,
                      ),
                      _makeDivider(),
                      CompleteAndCancelButton(() async {
                        ref.read(homeProvider.notifier).setSortBy(
                            ref.watch(sortSelectionProvider).orderBy,
                            ref.watch(sortSelectionProvider).sortBy,
                            ref.watch(sortSelectionProvider).topup);
                        await ref.read(homeProvider.notifier).setData();
                        Navigator.pop(context);
                      }, () {
                        Navigator.pop(context);
                      }),
                    ],
                  );
                }),
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
    return ref.watch(homeProvider).selectionMode
        ? _selectionMode()
        : normalMode();
  }
}
