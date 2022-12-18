import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

import '../../../provider/add_reminder/datetime/repeat_setting_provider.dart';

class RepeatSettingView {
  int? days; //繰り返しの間隔 or デフォルトの選択肢(マイナス)

  final int numberOfCharacters = 5;

  RepeatSettingView(this.days);

  /*
   * デフォルトオプション用のボタンを作成する
   * @param text : ボタンに表示するテキスト
   * @param value : ボタンの値
   * @param provider : RepeatSettingProvider
   * @param context : BuildContext
   * @return Widget : ボタン
   */
  Widget _makeButton(
    String text,
    int value,
    RepeatSettingProvider provider,
    BuildContext context,
  ) {
    return TextButton(
      onPressed: () {
        provider.setDays(value);
      },
      style: TextButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: (value == provider.option)
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
          child: ChangeNotifierProvider(
            create: (_) => RepeatSettingProvider(context, days),
            child: Consumer<RepeatSettingProvider>(
              builder: (context, provider, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _makeButton(
                      "One day",
                      provider.everyday,
                      provider,
                      context,
                    ),
                    _createDivider(context),
                    _makeButton(
                      "One week",
                      provider.everyWeek,
                      provider,
                      context,
                    ),
                    _createDivider(context),
                    _makeButton(
                      "One month",
                      provider.everyMonth,
                      provider,
                      context,
                    ),
                    _createDivider(context),
                    _makeButton(
                      "One year",
                      provider.everyYear,
                      provider,
                      context,
                    ),
                    _createDivider(context),
                    _makeButton(
                      "Custom",
                      provider.custom,
                      provider,
                      context,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.only(bottom: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .fontSize! *
                                  numberOfCharacters,
                              child: TextField(
                                enabled: provider.option == 0 ? true : false,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: provider.controller,
                                style: Theme.of(context).textTheme.bodyText1,
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
                                  provider.onChanged(value);
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Text(
                                provider.controller.text == "1"
                                    ? AppLocalizations.of(context)!.day
                                    : AppLocalizations.of(context)!.days,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _createDivider(context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.cancelButton,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              provider.days == 0
                                  ? provider.option
                                  : provider.days,
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.ok,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
