import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/shared_preferences/keys.dart';
import 'package:reminder/multilingualization/app_localizations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reminder/provider/main_provider.dart';
import 'package:reminder/provider/setting/deletion/deletion_provider.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';
import 'package:reminder/view/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'provider/home/home_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<void> autoDeleteReminder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? daysToDelete = prefs.getInt(SharedPreferencesKeys.dayToDelete);
    if (daysToDelete == null) return;

    var time = DateTime.now()
        .subtract(Duration(days: daysToDelete))
        .millisecondsSinceEpoch
        .toString();
    var nt = NotificationsTable();
    await nt.delete(
      where:
          "${NotificationsTable.frequencyKey} == 0 and ${NotificationsTable.timeKey} <= ?",
      whereArgs: [
        time,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MainProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeletionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          Future<void> init() async {
            await provider.setColors();

            await autoDeleteReminder();
          }

          return FutureBuilder(
            future: init(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) =>
                MaterialApp(
              theme: provider.getTheme(),
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
            ),
          );
        },
      ),
    );
  }
}
