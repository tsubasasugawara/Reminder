import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:reminder/components/brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  List<int> colors = [
    0xffe5a323, //パンプキン
    0xff009b9f, //ターコイズ
    0xffd3381c, //赤
    0xff82ae46, //鶸萌黄
    0xffe198b4, //桃花色
    0xff2ca9e1, //天色
    0xffffff00, //黄色
    0xffaa4c8f, //梅紫
    0xffe95464, //韓紅
    0xff4169e1, //royalblue
    0xff00a968, //エメラルドグリーン
    0xff9400d3, //darkviolet
  ];

  late String uiMode; // D:dark, L:light, A:auto
  late Color primaryColor;

  int selectedIndex = 0;

  Color backgroundColor = const Color.fromARGB(255, 40, 40, 40);
  Color barColor = const Color.fromARGB(255, 50, 50, 50);
  Color textColor = const Color.fromARGB(255, 225, 225, 225);
  Color hintTextColor = Colors.grey;
  Color error = Colors.red;
  Color dialogBackground = const Color.fromARGB(255, 40, 40, 40);
  Color elevatedButtonBackground = const Color.fromARGB(255, 50, 50, 50);

  String primaryColorKey = "primaryColor";
  String uiModeKey = "uiModeKey";

  ThemeProvider() {
    primaryColor = backgroundColor;
  }

  Future<void> setColors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorCode = prefs.getInt(primaryColorKey) ?? 0xffe95464;
    primaryColor = Color(colorCode);

    selectedIndex = getIndex();

    uiMode = prefs.getString(uiModeKey) ?? "A";

    String tmpUiMode = uiMode == "A"
        ? SchedulerBinding.instance!.window.platformBrightness ==
                Brightness.dark
            ? "D"
            : "L"
        : uiMode;
    if (tmpUiMode == "D") {
      _darkTheme();
    } else {
      _whiteTheme();
    }
  }

  void _darkTheme() {
    backgroundColor = const Color.fromARGB(255, 40, 40, 40);
    barColor = const Color.fromARGB(255, 50, 50, 50);
    textColor = const Color.fromARGB(255, 225, 225, 225);
    hintTextColor = Colors.grey;
    error = Colors.red;
    dialogBackground = const Color.fromARGB(255, 40, 40, 40);
    elevatedButtonBackground = const Color.fromARGB(255, 40, 40, 40);
  }

  void _whiteTheme() {
    backgroundColor = Colors.white;
    barColor = Colors.white;
    textColor = const Color.fromARGB(255, 30, 30, 30);
    hintTextColor = const Color.fromARGB(255, 60, 60, 60);
    error = Colors.red;
    dialogBackground = Colors.white;
    elevatedButtonBackground = Colors.white;
  }

  Future<void> changeUiMode(String mode) async {
    if (mode == "D") {
      uiMode = "D";
    } else if (mode == "L") {
      uiMode = "L";
    } else {
      uiMode = "A";
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(uiModeKey, uiMode);

    notifyListeners();
  }

  ThemeData? getTheme() {
    return ThemeData(
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      errorColor: error,
      hintColor: hintTextColor,
      backgroundColor: backgroundColor,
      bottomAppBarColor: barColor,
      dialogBackgroundColor: dialogBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(
          color: textColor,
        ),
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: textColor,
        ),
        bodyText1: TextStyle(
          color: textColor,
        ),
        bodyText2: const TextStyle(color: Colors.black),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: barColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionColor: primaryColor,
        selectionHandleColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            barColor,
          ),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: backgroundColor,
        dialTextColor: judgeBlackWhite(backgroundColor),
        helpTextStyle: TextStyle(
          color: hintTextColor,
        ),
      ),
      dialogTheme: DialogTheme(
        contentTextStyle: TextStyle(
          color: judgeBlackWhite(backgroundColor),
        ),
      ),
    );
  }

  void changeThemeColor(int colorCode) async {
    primaryColor = Color(colorCode);

    selectedIndex = getIndex();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(primaryColorKey, colorCode);

    notifyListeners();
  }

  int getIndex() {
    for (int i = 0; i < colors.length; i++) {
      if (primaryColor.value == colors[i]) return i;
    }
    return -1;
  }
}
