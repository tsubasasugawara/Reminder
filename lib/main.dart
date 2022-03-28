import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/provider/add_reminder_provider.dart';
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
        ChangeNotifierProvider<AddReminderProvider>(
          create: (context) => AddReminderProvider(),
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
