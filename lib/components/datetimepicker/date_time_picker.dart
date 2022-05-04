import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/datetimepicker/time_provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

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

  DateTimePicker(DateTime dt) {
    year = dt.year;
    month = dt.month;
    day = dt.day;
    hour = dt.hour;
    minute = dt.minute;
  }

  DateTime setDateTime() {
    var dt = DateTime(year, month, day, hour, minute);
    var dtn = DateTime.now();
    if (dt.millisecondsSinceEpoch - dtn.millisecondsSinceEpoch < 0) {
      return dtn;
    } else {
      return dt;
    }
  }

  Future<DateTime?> showDateTimePicker(
    BuildContext context,
    Color backgroundColor,
    ThemeData themeData,
  ) async {
    final double textScaleFactor =
        math.min(MediaQuery.of(context).textScaleFactor, 1.3);
    final Size dialogSize = _dialogSize(context) * textScaleFactor;

    return await showDialog(
      context: context,
      builder: (context) {
        return Theme(
            data: themeData,
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
                              child: CalendarDatePicker(
                                firstDate: DateTime.now(),
                                initialDate: setDateTime(),
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
                                    icon:
                                        const Icon(Icons.watch_later_outlined),
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.cancelButton,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                      DateTime(year, month, day, hour, minute),
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
            ));
      },
    ).then((value) => value);
  }

  Size _dialogSize(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    switch (orientation) {
      case Orientation.portrait:
        return _calendarPortraitDialogSize;
      case Orientation.landscape:
        return _calendarLandscapeDialogSize;
    }
  }
}
