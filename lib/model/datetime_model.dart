class DateTimeModel {
  int year = 0;
  int month = 0;
  int day = 0;
  int hour = 0;
  int minute = 0;

  DateTimeModel(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    year = dateTime.year;
    month = dateTime.month;
    day = dateTime.day;
    hour = dateTime.hour;
    minute = dateTime.minute;
  }
}
