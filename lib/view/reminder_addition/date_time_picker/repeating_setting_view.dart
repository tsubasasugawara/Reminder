import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/utils/complete_and_cancel_button/complete_and_cancel_button.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../model/db/notifications.dart';
import '../../../provider/reminder_addition/datetime/repeating_setting/repeating_setting_provider.dart';

class RepeatingSettingView {
  int? days; //繰り返しの間隔 or デフォルトの選択肢(マイナス)

  final int numberOfCharacters = 5;

  RepeatingSettingView(this.days);

  /*
   * デフォルトオプション用のボタンを作成する
   * @param text : ボタンに表示するテキスト
   * @param value : ボタンの値
   * @param provider : RepeatingSettingProvider
   * @param context : BuildContext
   * @return Widget : ボタン
   */
  Widget _makeButton(
    String text,
    int value,
    BuildContext context,
  ) {
    return Consumer(builder: (context, ref, child) {
      var option = ref.watch(repeatingSettingProvider).option;

      return TextButton(
        onPressed: () {
          context.read(repeatingSettingProvider.notifier).setDays(value);
        },
        style: TextButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        child: (value == option)
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
    });
  }

  Widget repeatingIntervalForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: const EdgeInsets.only(bottom: 5),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Consumer(
          builder: (context, ref, child) {
            var option = ref.watch(repeatingSettingProvider).option;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: Theme.of(context).textTheme.bodyLarge!.fontSize! *
                      numberOfCharacters,
                  child: TextField(
                    enabled: option == 0 ? true : false,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: ref.read(repeatingSettingProvider).controller,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).highlightColor,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.all(10),
                    ),
                    onChanged: (value) {
                      ref
                          .read(repeatingSettingProvider.notifier)
                          .onChanged(value);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    context.read(repeatingSettingProvider).controller.text ==
                            "1"
                        ? AppLocalizations.of(context)!.day
                        : AppLocalizations.of(context)!.days,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /*
   * Dividerを作成する
   * @param context : BuildContext
   * @return Widget : 作成したDivider
   */
  Widget _createDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).dividerColor,
      height: 1,
      thickness: 1,
    );
  }

  /*
   * 繰り返しの間隔を設定するダイアログを表示する
   * @param context : BuildContext
   */
  Future<int?> showSettingRepeatDays(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  AppLocalizations.of(context)!.repeatingInterval,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              _createDivider(context),
              _makeButton(
                AppLocalizations.of(context)!.everyday,
                Notifications.everyday,
                context,
              ),
              _createDivider(context),
              _makeButton(
                AppLocalizations.of(context)!.everyWeek,
                Notifications.everyWeek,
                context,
              ),
              _createDivider(context),
              _makeButton(
                AppLocalizations.of(context)!.everyMonth,
                Notifications.everyMonth,
                context,
              ),
              _createDivider(context),
              _makeButton(
                AppLocalizations.of(context)!.everyYear,
                Notifications.everyYear,
                context,
              ),
              _createDivider(context),
              _makeButton(
                AppLocalizations.of(context)!.custom,
                Notifications.custom,
                context,
              ),
              repeatingIntervalForm(context),
              _createDivider(context),
              _makeButton(
                AppLocalizations.of(context)!.notRepeat,
                Notifications.notRepeating,
                context,
              ),
              _createDivider(context),
              // TODO:同じ関数を渡しているため意味がない
              CompleteAndCancelButton(
                () {
                  Navigator.pop(context);
                },
                () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
