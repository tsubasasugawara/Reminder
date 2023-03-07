import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/multilingualization/app_localizations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';
import 'package:reminder/view/home/home_view.dart';

import 'provider/setting/auto_delete/auto_delete_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<void> settings(WidgetRef ref) async {
    await ref.read(themeProvider.notifier).setColors();
    await ref.read(homeProvider.notifier).setData();
    await AutoDeletionProvider.deleteReminder();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // ignore: unused_local_variable
        var watchTheme = ref.watch(themeProvider);

        return FutureBuilder(
          future: settings(ref),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) =>
              MaterialApp(
            theme: ref.read(themeProvider.notifier).getTheme(),
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
    );
  }
}
