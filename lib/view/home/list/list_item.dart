import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

// ignore: must_be_immutable
class ListItem extends StatelessWidget {
  late bool selected; // 選択しているかどうか
  late String title; // タイトル
  late int setAlarm; // アラームがセットされているかどうか
  late int time; // アラームの時間

  ListItem(
    this.selected,
    this.title,
    this.setAlarm,
    this.time, {
    Key? key,
  }) : super(key: key);

  /*
   * 時間を整形し、文字列として返す
   * @param milliseconds:ミリ秒表現の時間
   * @param context:BuildContext
   * @return String:整形後の時間の文字列
   */
  String _dateTimeFormat(int milliseconds, BuildContext context) {
    var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    var now = DateTime.now();

    var diff = dt.difference(now);

    if (diff.inMilliseconds <= 0) {
      return AppLocalizations.of(context)!.notifiedMsg;
    } else {
      return DateFormat(AppLocalizations.of(context)!.dateTimeFormat)
          .format(dt);
    }
  }

  // アラームがオンなら、その時間を返す
  String _alarmOnOff(BuildContext context) {
    if (setAlarm == 1) {
      return _dateTimeFormat(time, context);
    } else {
      return AppLocalizations.of(context)!.setAlarmOff;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(
            color: selected
                ? Theme.of(context).primaryColor
                : Theme.of(context).hintColor,
            width: selected ? 2.5 : 1.5,
          ),
          color: Theme.of(context).backgroundColor,
        ),
        padding: const EdgeInsets.all(10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyText1?.apply(
                            fontSizeDelta: 6,
                          ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        _alarmOnOff(context),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: setAlarm == 1
                    ? Icon(
                        Icons.alarm_on,
                        color: Theme.of(context).primaryColor,
                      )
                    : Icon(
                        Icons.alarm_off,
                        color: Theme.of(context).hintColor,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
