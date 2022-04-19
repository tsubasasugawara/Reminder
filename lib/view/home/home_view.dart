import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/home_list_provider.dart';
import 'package:reminder/values/colors.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';
import 'package:reminder/view/home/home_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => HomeListProvider()),
      child: Consumer<HomeListProvider>(
        builder: ((context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.appTitle,
                style: const TextStyle(color: AppColors.textColor),
              ),
            ),
            body: HomeList(provider),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AddReminderView(null, null, null, null, null);
                    },
                  ),
                );
                provider.getData();
              },
              child: const Icon(
                Icons.add,
                size: 30,
                color: AppColors.backgroundColor,
              ),
              backgroundColor: AppColors.mainColor,
            ),
          );
        }),
      ),
    );
  }
}
