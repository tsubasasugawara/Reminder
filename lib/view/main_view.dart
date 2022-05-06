import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/provider/main_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';

// ignore: must_be_immutable
class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            provider.index == 0
                ? AppLocalizations.of(context)!.appTitle
                : AppLocalizations.of(context)!.setting,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: provider.setWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) => FloatingActionButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AddReminderView();
                  },
                ),
              );
              homeProvider.update();
            },
            child: Icon(
              Icons.add,
              size: 30,
              color: Theme.of(context).backgroundColor,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: provider.index,
          onTap: (int index) {
            provider.changeIndex(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.home,
              ),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.settings,
              ),
              label: AppLocalizations.of(context)!.setting,
            ),
          ],
        ),
      ),
    );
  }
}
