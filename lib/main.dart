import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/provider/datetime_provider.dart';
import 'package:reminder/provider/home_provider.dart';
import 'package:reminder/view/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DateTimeProvider>(
          create: (context) => DateTimeProvider(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Reminder',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const HomeView(),
      ),
    );
  }
}
