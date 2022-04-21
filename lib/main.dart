import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations_delegate.dart';
import 'package:reminder/values/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reminder/view/main_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: AppColors.mainMaterialColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
        ),
        bottomAppBarColor: AppColors.backgroundColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundColor,
          unselectedItemColor: AppColors.textColor,
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
      home: MainView(),
    );
  }
}
