import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/brightness.dart';
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
          title: Provider.of<HomeProvider>(context).selectedMode
              ? null
              : Text(
                  provider.index == 0
                      ? AppLocalizations.of(context)!.appTitle
                      : AppLocalizations.of(context)!.setting,
                  style: Theme.of(context).textTheme.headline6,
                ),
          actions: Provider.of<HomeProvider>(context).selectedMode
              ? [
                  Consumer<HomeProvider>(
                    builder: (context, homeProvider, child) => Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            homeProvider.allSelect(false);
                          },
                          icon: const Icon(Icons.cancel_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            homeProvider.allSelect(true);
                          },
                          icon: const Icon(Icons.select_all),
                        ),
                        IconButton(
                          onPressed: () async {
                            await homeProvider.deleteButton(context);
                            homeProvider.allSelect(false);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ]
              : null,
        ),
        body: provider.setWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) => Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom <= 0,
            child: Consumer<HomeProvider>(
              builder: (context, homeProvider, child) => FloatingActionButton(
                onPressed: () async {
                  if (homeProvider.selectedMode) {
                    await homeProvider.deleteButton(context);
                    homeProvider.allSelect(false);
                  } else {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddReminderView();
                        },
                      ),
                    );
                    homeProvider.update();
                  }
                },
                child: Icon(
                  homeProvider.selectedMode ? Icons.delete : Icons.add,
                  size: 30,
                  color: judgeBlackWhite(Theme.of(context).primaryColor),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
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
