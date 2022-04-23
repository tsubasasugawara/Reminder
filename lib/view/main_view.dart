import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/provider/main_provider.dart';

// ignore: must_be_immutable
class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => MainProvider()),
      child: Consumer<MainProvider>(
        builder: (context, provider, child) {
          return provider.setWidget();
        },
      ),
    );
  }
}
