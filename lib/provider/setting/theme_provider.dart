import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  List<int> colors = [
    0xffc0c0c0,
    0xff00bfff,
    0xff4CAF50,
    0xffff0000,
    0xffffe4b5,
    0xff00ffff,
    0xffffff00,
    0xffff00ff,
    0xffa52a2a,
    0xff4169e1,
    0xffffa500,
    0xff9400d3,
  ];

  late Color primaryColor;

  Color backgroundColor = const Color.fromARGB(255, 10, 10, 10);
  Color textColor = const Color.fromARGB(255, 225, 225, 225);
  Color hintTextColor = Colors.grey;
  Color error = Colors.red;
  Color dialogBackground = const Color.fromARGB(255, 20, 20, 20);
  Color elevatedButtonBackground = const Color.fromARGB(255, 50, 50, 50);

  String primaryColorKey = "primaryColor";

  ThemeProvider() {
    primaryColor = backgroundColor;
  }

  Future<void> setPrimaryColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int colorCode = prefs.getInt(primaryColorKey) ?? 0xff00ff00;
    primaryColor = Color(colorCode);
  }

  ThemeData? getTheme() {
    return ThemeData(
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
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
            elevatedButtonBackground,
          ),
        ),
      ),
    );
  }

  void changeThemeColor(int colorCode) async {
    primaryColor = Color(colorCode);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(primaryColorKey, colorCode);

    notifyListeners();
  }

  int getIndex() {
    for (int i = 0; i < colors.length; i++) {
      if (primaryColor.value == colors[i]) return i;
    }
    return 2;
  }
}
