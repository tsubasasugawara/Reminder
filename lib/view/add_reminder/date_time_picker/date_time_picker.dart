import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/brightness/brightness.dart';
import 'package:reminder/provider/add_reminder/datetime/time_provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';
import 'package:reminder/view/add_reminder/date_time_picker/repeat_setting_view.dart';

class DateTimePicker {
  static const Size _calendarPortraitDialogSize = Size(330.0, 518.0);
  static const Size _calendarLandscapeDialogSize = Size(496.0, 346.0);
  static const Duration _dialogSizeAnimationDuration =
      Duration(milliseconds: 200);

  int year = 0;
  int month = 0;
  int day = 0;
  int hour = 0;
  int minute = 0;

  /*
   * コンストラクタ
   * @param dt : 日時の初期値
   */
  DateTimePicker(DateTime dt) {
    year = dt.year;
    month = dt.month;
    day = dt.day;
    hour = dt.hour;
    minute = dt.minute;
  }

  /*
   * 日時を取得
   * @return DateTime : 時刻
   */
  DateTime _getDateTime() {
    var dt = DateTime(year, month, day, hour, minute);
    var dtn = DateTime.now();
    if (dt.millisecondsSinceEpoch - dtn.millisecondsSinceEpoch < 0) {
      return dtn;
    } else {
      return dt;
    }
  }

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
   * DateTimePickerを表示する
   * @param context : BuildContext
   * @param backgroundColor : バックグランドカラー
   * @return DateTime? : 選択した日時
   */
  Future<DateTime?> showDateTimePicker(
    BuildContext context,
    Color backgroundColor,
  ) async {
    final double textScaleFactor =
        math.min(MediaQuery.of(context).textScaleFactor, 1.3);
    final Size dialogSize = _dialogSize(context) * textScaleFactor;

    return await showDialog(
      context: context,
      builder: (context) {
        return Consumer<ThemeProvider>(
          builder: (context, provider, child) => Theme(
              data: provider.uiMode == "D"
                  ? Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: Theme.of(context).primaryColor,
                        onSurface: judgeBlackWhite(backgroundColor),
                        onPrimary:
                            judgeBlackWhite(Theme.of(context).primaryColor),
                      ),
                    )
                  : Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Theme.of(context).primaryColor,
                        onSurface: judgeBlackWhite(backgroundColor),
                        onPrimary:
                            judgeBlackWhite(Theme.of(context).primaryColor),
                      ),
                    ),
              child: Dialog(
                insetPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
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
                                child: CalendarDatePicker(
                                  firstDate: DateTime.now(),
                                  initialDate: _getDateTime(),
                                  lastDate: DateTime(
                                    DateTime.now().year + 10,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                  ),
                                  onDateChanged: (DateTime value) {
                                    year = value.year;
                                    month = value.month;
                                    day = value.day;
                                  },
                                ),
                              ),
                              ChangeNotifierProvider(
                                create: (BuildContext context) =>
                                    TimeProvider(hour, minute),
                                child: Consumer<TimeProvider>(
                                  builder: (context, timeProvider, child) =>
                                      Container(
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        var picked = await showTimePicker(
                                          context: context,
                                          confirmText:
                                              AppLocalizations.of(context)!.ok,
                                          initialTime: TimeOfDay(
                                              hour: hour, minute: minute),
                                          builder: (context, child) {
                                            return child!;
                                          },
                                        );
                                        if (picked != null) {
                                          hour = picked.hour;
                                          minute = picked.minute;
                                          timeProvider.changeTime(hour, minute);
                                        }
                                      },
                                      icon: Icon(
                                        Icons.watch_later_outlined,
                                        color: judgeBlackWhite(
                                          backgroundColor,
                                        ),
                                      ),
                                      label: Text(
                                        DateFormat(AppLocalizations.of(context)!
                                                .timeFormat)
                                            .format(
                                          DateTime(
                                            year,
                                            month,
                                            day,
                                            hour,
                                            minute,
                                          ),
                                        ),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              RepeatSettingView(backgroundColor),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .cancelButton,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        DateTime(
                                            year, month, day, hour, minute),
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.ok,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )),
        );
      },
    ).then((value) => value);
  }
}
