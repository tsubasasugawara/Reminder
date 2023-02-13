import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/provider/reminder_addition/datetime/datetime_provider.dart';
import 'package:reminder/provider/reminder_addition/datetime/repeating_setting/repeating_setting_provider.dart';
import 'package:reminder/utils/brightness/brightness.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';
import 'package:reminder/utils/complete_and_cancel_button/complete_and_cancel_button.dart';
import 'package:reminder/view/reminder_addition/date_time_picker/repeating_setting_view.dart';

import '../../../utils/pair/pair.dart';

class DateTimePicker {
  static const Size _calendarPortraitDialogSize = Size(330.0, 518.0);
  static const Size _calendarLandscapeDialogSize = Size(496.0, 346.0);
  static const Duration _dialogSizeAnimationDuration =
      Duration(milliseconds: 200);

  /*
   * ダイアログのサイズ
   * @param context : BuildContext
   * @return Size : サイズ
   */
  Size _dialogSize(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    switch (orientation) {
      case Orientation.portrait:
        return _calendarPortraitDialogSize;
      case Orientation.landscape:
        return _calendarLandscapeDialogSize;
    }
  }

  /*
   * 繰り返し間隔の設定ダイアログを表示するボタンを生成する
   * @param context : BuildContext
   * @param backgroundColor : Color
   * @return Widget : ダイアログを表示するボタン
   */
  Widget _generateRepeatSettingButton(
    BuildContext context,
    Color backgroundColor,
  ) {
    return Consumer(
      builder: (context, ref, child) {
        var days = ref.watch(repeatingSettingProvider).days;
        var option = ref.watch(repeatingSettingProvider).option;
        var buttonMsg =
            RepeatingSettingProvider.buttonMsg(context, days, option);

        return ElevatedButton.icon(
          icon: Icon(
            Icons.repeat,
            color: judgeBlackWhite(
              backgroundColor,
            ),
          ),
          label: Text(
            buttonMsg,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          onPressed: () async {
            await RepeatingSettingView(ref.read(repeatingSettingProvider).days)
                .showSettingRepeatDays(context);
          },
        );
      },
    );
  }

  /*
   * DateTimePickerを表示する
   * @param context : BuildContext
   * @param backgroundColor : バックグランドカラー
   * @return DateTime? : 選択した日時
   */
  Future<Pair<DateTime, int?>?> showDateTimePicker(
    BuildContext context,
    String uiMode,
    Color backgroundColor,
  ) async {
    final double textScaleFactor =
        math.min(MediaQuery.of(context).textScaleFactor, 1.3);
    final Size dialogSize = _dialogSize(context) * textScaleFactor;

    // TODO:値を変更したときにProviderの状態を変更しているため、キャンセルしても前の状態に戻らない(繰り返し頻度も同様)
    // 解決策:ダイアログを開いたときの値を保存しておく
    return await showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: uiMode == ThemeProviderData.darkTheme
              ? Theme.of(context).copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: Theme.of(context).primaryColor,
                    onSurface: judgeBlackWhite(backgroundColor),
                    onPrimary: judgeBlackWhite(Theme.of(context).primaryColor),
                  ),
                )
              : Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Theme.of(context).primaryColor,
                    onSurface: judgeBlackWhite(backgroundColor),
                    onPrimary: judgeBlackWhite(Theme.of(context).primaryColor),
                  ),
                ),
          child: Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            clipBehavior: Clip.antiAlias,
            child: AnimatedContainer(
              width: dialogSize.width,
              height: dialogSize.height,
              duration: _dialogSizeAnimationDuration,
              curve: Curves.easeIn,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: textScaleFactor,
                ),
                child: Builder(
                  builder: (BuildContext context) {
                    return Material(
                      color: backgroundColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Consumer(builder: (context, ref, child) {
                              return CalendarDatePicker(
                                firstDate: DateTime.now(),
                                initialDate: ref.read(dateTimeProvider).dt,
                                lastDate: DateTime(
                                  DateTime.now().year + 10,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                ),
                                onDateChanged: (DateTime value) {
                                  ref
                                      .read(dateTimeProvider.notifier)
                                      .changeDate(
                                        year: value.year,
                                        month: value.month,
                                        day: value.day,
                                      );
                                },
                              );
                            }),
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              var dt = ref.watch(dateTimeProvider).dt;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    var picked = await showTimePicker(
                                      context: context,
                                      confirmText:
                                          AppLocalizations.of(context)!.ok,
                                      initialTime: TimeOfDay(
                                          hour: dt.hour, minute: dt.minute),
                                      builder: (context, child) {
                                        return child!;
                                      },
                                    );
                                    if (picked != null) {
                                      ref
                                          .read(dateTimeProvider.notifier)
                                          .changeTime(
                                            hour: picked.hour,
                                            minute: picked.minute,
                                          );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.watch_later_outlined,
                                    color: judgeBlackWhite(
                                      backgroundColor,
                                    ),
                                  ),
                                  label: Text(
                                    ref
                                        .read(dateTimeProvider.notifier)
                                        .dateTimeFormat(
                                            AppLocalizations.of(context)!
                                                .timeFormat),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          _generateRepeatSettingButton(
                              context, backgroundColor),
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
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) => value);
  }
}
