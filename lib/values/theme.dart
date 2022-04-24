import 'package:flutter/material.dart';

class AppTheme {
  late Color backgroundColor;
  late Color textColor;
  late Color hintTextColor;
  late Color mainColor;
  late Color error;
  late Color dialogBackground;
  late Color elevatedButtonBackground;

  AppTheme() {
    _init();
  }

  Future<void> _init() async {
    backgroundColor = const Color.fromARGB(255, 10, 10, 10);
    textColor = const Color.fromARGB(255, 225, 225, 225);
    hintTextColor = Colors.grey;
    mainColor = Colors.green;
    error = Colors.red;
    dialogBackground = const Color.fromARGB(255, 20, 20, 20);
    elevatedButtonBackground = const Color.fromARGB(255, 50, 50, 50);
  }

  ThemeData getTheme() {
    return ThemeData(
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: mainColor,
      errorColor: error,
      hintColor: hintTextColor,
      backgroundColor: backgroundColor,
      bottomAppBarColor: backgroundColor,
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
        backgroundColor: backgroundColor,
        selectedItemColor: mainColor,
        unselectedItemColor: textColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: mainColor,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: mainColor,
        selectionColor: mainColor,
        selectionHandleColor: mainColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            elevatedButtonBackground,
          ),
        ),
      ),
    );
  }
}
