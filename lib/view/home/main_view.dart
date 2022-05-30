import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/brightness/brightness.dart';
import 'package:reminder/components/snack_bar/snackbar.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';
import 'package:reminder/view/home/home_list.dart';

import '../setting/setting.view.dart';

// ignore: must_be_immutable
class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          leading: provider.selectionMode
              ? IconButton(
                  icon: const Icon(Icons.close_sharp),
                  onPressed: () {
                    provider.changeMode(false);
                  },
                )
              : null,
          title: provider.selectionMode
              ? Text(
                  "  " +
                      Provider.of<HomeProvider>(context)
                          .selectedItemsCnt
                          .toString(),
                  style: Theme.of(context).textTheme.headline6,
                )
              : Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: Theme.of(context).textTheme.headline6,
                ),
          actions: provider.selectionMode
              ? [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          provider.allSelectOrNot(true);
                        },
                        icon: const Icon(Icons.select_all),
                      ),
                      IconButton(
                        onPressed: () async {
                          var res = await provider.deleteButton(context);
                          if (res) {
                            ShowSnackBar(
                              context,
                              AppLocalizations.of(context)!.deletedAlarm,
                              Theme.of(context).primaryColor,
                            );
                          }
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ]
              : null,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/1024.png',
                      width: 55,
                      height: 55,
                    ),
                    Text(
                      AppLocalizations.of(context)!.appTitle,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(AppLocalizations.of(context)!.setting),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SettingView();
                      },
                    ),
                  );
                  provider.update();
                  provider.allSelectOrNot(false);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(AppLocalizations.of(context)!.trash),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SettingView();
                      },
                    ),
                  );
                  provider.update();
                  provider.allSelectOrNot(false);
                },
              ),
            ],
          ),
        ),
        body: HomeList(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom <= 0,
          child: FloatingActionButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AddReminderView();
                  },
                ),
              );
              provider.update();
              provider.allSelectOrNot(false);
            },
            child: Icon(
              Icons.add,
              size: 30,
              color: judgeBlackWhite(Theme.of(context).primaryColor),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
