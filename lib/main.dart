import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reminder/view/main_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color.fromARGB(255, 10, 10, 10);
    const Color textColor = Color.fromARGB(255, 225, 225, 225);
    const Color hintTextColor = Colors.grey;
    const Color mainColor = Colors.green;
    const Color error = Colors.red;
    const Color dialogBackground = Color.fromARGB(255, 20, 20, 20);

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: mainColor,
        errorColor: error,
        hintColor: hintTextColor,
        backgroundColor: backgroundColor,
        bottomAppBarColor: backgroundColor,
        dialogBackgroundColor: dialogBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          iconTheme: IconThemeData(
            color: textColor,
          ),
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: textColor,
          ),
          bodyText1: TextStyle(
            color: textColor,
          ),
          bodyText2: TextStyle(color: Colors.black),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: backgroundColor,
          selectedItemColor: mainColor,
          unselectedItemColor: textColor,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: mainColor,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: mainColor,
          selectionColor: mainColor,
          selectionHandleColor: mainColor,
        ),
      ),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ja'),
      ],
      home: const MainView(),
    );
  }
}
