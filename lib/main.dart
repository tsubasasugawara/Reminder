import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/multilingualization/app_localizations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reminder/provider/home/selection_item_provider.dart';
import 'package:reminder/provider/main_provider.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';
import 'package:reminder/view/main_view.dart';

import 'provider/home/home_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          create: (_) => HomeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: provider.setColors(),
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
