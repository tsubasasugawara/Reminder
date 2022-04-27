class DateTimeModel {
  int _year = 0;
  int _month = 0;
  int _day = 0;
  int _hour = 0;
  int _minute = 0;

  DateTimeModel(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    _year = dateTime.year;
    _month = dateTime.month;
    _day = dateTime.day;
    _hour = dateTime.hour;
    _minute = dateTime.minute;
  }

  void changeDateTimeVariables(DateTime dt) {
    _year = dt.year;
    _month = dt.month;
    _day = dt.day;
    _hour = dt.hour;
    _minute = dt.minute;
  }

  DateTime createDateTime() {
    return DateTime(_year, _month, _day, _hour, _minute);
  }
}
