class DateTimeModel {
  int _year = 0;
  int _month = 0;
  int _day = 0;
  int _hour = 0;
  int _minute = 0;

  /// コンストラクタ
  /// * `milliseconds` : 日時の初期値
  DateTimeModel(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    _year = dateTime.year;
    _month = dateTime.month;
    _day = dateTime.day;
    _hour = dateTime.hour;
    _minute = dateTime.minute;
  }

  /// 日時を変更
  /// * `dt` : 変更する日時のデータ
  void changeDateTime(DateTime dt) {
    _year = dt.year;
    _month = dt.month;
    _day = dt.day;
    _hour = dt.hour;
    _minute = dt.minute;
  }

  /// 現在保存されている日時情報を基にインスタンス化
  /// * @return `DateTime` : DateTimeインスタンス
  DateTime createDateTime() {
    return DateTime(_year, _month, _day, _hour, _minute);
  }
}
