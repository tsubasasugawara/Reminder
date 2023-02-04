import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/utils/brightness/brightness.dart';
import '../setting.dart';

final themeProvider = StateNotifierProvider<ThemeProvider, ThemeProviderData>(
    (ref) => ThemeProvider());

class ThemeProviderData {
  static const darkTheme = "D";
  static const lightTheme = "L";
  static const auto = "A";

  final List<int> colors = [
    0xffe5a323, //パンプキン
    0xff009b9f, //ターコイズ
    0xffd3381c, //赤
    0xff82ae46, //鶸萌黄
    0xffe198b4, //桃花色
    0xff2ca9e1, //天色
    0xffffff00, //黄色
    0xffaa4c8f, //梅紫
    0xffe95464, //韓紅
    0xff4169e1, //ロイヤルブルー
    0xff00a968, //エメラルドグリーン
    0xff9400d3, //ダークバイオレット
  ];

  late String uiMode; //D:ダーク, L:ライト, A:自動
  late Color primaryColor;

  int selectedIndex = 0; //現在のプライマリーカラーの番号

  Color backgroundColor = const Color.fromARGB(255, 40, 40, 40);
  Color barColor = const Color.fromARGB(255, 50, 50, 50);
  Color textColor = const Color.fromARGB(255, 225, 225, 225);
  Color hintTextColor = Colors.grey;
  Color error = Colors.red;
  Color dialogBackground = const Color.fromARGB(255, 40, 40, 40);
  Color elevatedButtonBackground = const Color.fromARGB(255, 50, 50, 50);
  Color canvasColor = const Color.fromARGB(255, 60, 60, 60);
  Color highlightColor = const Color.fromARGB(255, 50, 50, 50);

  ThemeProviderData({
    this.uiMode = auto,
    this.selectedIndex = 0,
    this.primaryColor = const Color.fromARGB(255, 40, 40, 40),
    this.backgroundColor = const Color.fromARGB(255, 40, 40, 40),
    this.barColor = const Color.fromARGB(255, 50, 50, 50),
    this.textColor = const Color.fromARGB(255, 225, 225, 225),
    this.hintTextColor = Colors.grey,
    this.error = Colors.red,
    this.dialogBackground = const Color.fromARGB(255, 40, 40, 40),
    this.elevatedButtonBackground = const Color.fromARGB(255, 50, 50, 50),
    this.canvasColor = const Color.fromARGB(255, 60, 60, 60),
    this.highlightColor = const Color.fromARGB(255, 50, 50, 50),
  });

  ThemeProviderData copyWith({
    String? uiMode,
    int? selectedIndex,
    Color? primaryColor,
    Color? backgroundColor,
    Color? barColor,
    Color? textColor,
    Color? hintTextColor,
    Color? error,
    Color? dialogBackground,
    Color? elevatedButtonBackground,
    Color? canvasColor,
    Color? highlightColor,
  }) {
    return ThemeProviderData(
      uiMode: uiMode ?? this.uiMode,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      barColor: barColor ?? this.barColor,
      textColor: textColor ?? this.textColor,
      hintTextColor: hintTextColor ?? this.hintTextColor,
      error: error ?? this.error,
      dialogBackground: dialogBackground ?? this.dialogBackground,
      elevatedButtonBackground:
          elevatedButtonBackground ?? this.elevatedButtonBackground,
      canvasColor: canvasColor ?? this.canvasColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }
}

//App theme.
class ThemeProvider extends StateNotifier<ThemeProviderData> {
  ThemeProvider() : super(ThemeProviderData());

  //プライマリーカラーとテーマをセットする
  Future<void> setColors() async {
    int colorCode = await Setting.getInt(Setting.primaryColorKey) ?? 0xffe198b4;
    state.primaryColor = Color(colorCode);
    state.selectedIndex = _getIndex();

    state.uiMode =
        await Setting.getString(Setting.uiModeKey) ?? ThemeProviderData.auto;
    String tmpUiMode = state.uiMode == ThemeProviderData.auto
        ? SchedulerBinding.instance.window.platformBrightness == Brightness.dark
            ? ThemeProviderData.darkTheme
            : ThemeProviderData.lightTheme
        : state.uiMode;
    if (tmpUiMode == ThemeProviderData.darkTheme) {
      _darkTheme();
    } else {
      _lightTheme();
    }
  }

  /*
   * プライマリーカラーを変更する
   * @param colorCode:16進数のカラーコード
   */
  void changePrimaryColor(int colorCode) async {
    var primaryColor = Color(colorCode);
    var selectedIndex = _getIndex();
    await Setting.setInt(Setting.primaryColorKey, colorCode);

    state = state.copyWith(
      primaryColor: primaryColor,
      selectedIndex: selectedIndex,
    );
  }

  //ダークテーマに変更
  void _darkTheme() {
    state.backgroundColor = const Color.fromARGB(255, 40, 40, 40);
    state.barColor = const Color.fromARGB(255, 50, 50, 50);
    state.textColor = const Color.fromARGB(255, 225, 225, 225);
    state.hintTextColor = Colors.grey;
    state.error = Colors.red;
    state.dialogBackground = const Color.fromARGB(255, 40, 40, 40);
    state.elevatedButtonBackground = const Color.fromARGB(255, 40, 40, 40);
    state.canvasColor = const Color.fromARGB(255, 60, 60, 60);
    state.highlightColor = const Color.fromARGB(255, 50, 50, 50);
  }

  //ライトテーマに変更
  void _lightTheme() {
    state.backgroundColor = Colors.white;
    state.barColor = Colors.white;
    state.textColor = const Color.fromARGB(255, 30, 30, 30);
    state.hintTextColor = const Color.fromARGB(255, 60, 60, 60);
    state.error = Colors.red;
    state.dialogBackground = Colors.white;
    state.elevatedButtonBackground = Colors.white;
    state.canvasColor = const Color.fromARGB(255, 240, 240, 240);
    state.highlightColor = const Color.fromARGB(255, 220, 220, 220);
  }

  /*
   * テーマを保存
   * @param mode:選択されたモード
   */
  Future<void> changeUiMode(String mode) async {
    if (mode != ThemeProviderData.darkTheme &&
        mode != ThemeProviderData.lightTheme) mode = ThemeProviderData.auto;

    await Setting.setString(Setting.uiModeKey, mode);

    state = state.copyWith(uiMode: mode);
  }

  //ThemeDataを作成し、返す
  ThemeData? getTheme() {
    return ThemeData(
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: state.backgroundColor,
      primaryColor: state.primaryColor,
      errorColor: state.error,
      hintColor: state.hintTextColor,
      backgroundColor: state.backgroundColor,
      bottomAppBarColor: state.barColor,
      dialogBackgroundColor: state.dialogBackground,
      unselectedWidgetColor: judgeBlackWhite(state.backgroundColor),
      highlightColor: state.highlightColor,
      appBarTheme: AppBarTheme(
        backgroundColor: state.backgroundColor,
        iconTheme: IconThemeData(
          color: state.textColor,
        ),
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: state.textColor,
        ),
        bodyText1: TextStyle(
          color: state.textColor,
        ),
        bodyText2: const TextStyle(color: Colors.black),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: state.barColor,
        selectedItemColor: state.primaryColor,
        unselectedItemColor: state.textColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: state.primaryColor,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: state.primaryColor,
        selectionColor: state.primaryColor,
        selectionHandleColor: state.primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            state.barColor,
          ),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: state.backgroundColor,
        dialTextColor: judgeBlackWhite(state.backgroundColor),
        helpTextStyle: TextStyle(
          color: state.hintTextColor,
        ),
      ),
      dialogTheme: DialogTheme(
        contentTextStyle: TextStyle(
          color: judgeBlackWhite(state.backgroundColor),
        ),
      ),
      canvasColor: state.canvasColor,
    );
  }

  //現在のプライマリーカラーの番号を返す
  int _getIndex() {
    for (int i = 0; i < state.colors.length; i++) {
      if (state.primaryColor.value == state.colors[i]) return i;
    }
    return -1;
  }
}
