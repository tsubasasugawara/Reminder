import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/brightness/brightness.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';
import 'package:reminder/view/home/appBar/actions.dart' as actions;
import 'package:reminder/view/trash/trash.dart';

import '../../model/db/db.dart';
import '../setting/setting_view.dart';
import 'list/list_item.dart';

// ignore: must_be_immutable
class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  Widget? _leading(HomeProvider provider, BuildContext context) {
    return provider.selectionMode
        ? IconButton(
            icon: const Icon(Icons.close_sharp),
            onPressed: () {
              provider.changeMode(false);
            },
          )
        : null;
  }

  Widget _title(HomeProvider provider, BuildContext context) {
    return provider.selectionMode
        ? Text(
            "  " +
                Provider.of<HomeProvider>(context).selectedItemsCnt.toString(),
            style: Theme.of(context).textTheme.headline6,
          )
        : Text(
            AppLocalizations.of(context)!.appTitle,
            style: Theme.of(context).textTheme.headline6,
          );
  }

  Widget _drawer(HomeProvider provider, BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "images/1024.png",
                  width: 50,
                  height: 50,
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
              Navigator.pop(context);
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SettingView();
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
              Navigator.pop(context);
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const Trash();
                  },
                ),
              );
              provider.update();
              provider.allSelectOrNot(false);
            },
          ),
        ],
      ),
    );
  }

  Widget? _fab(HomeProvider provider, BuildContext context) {
    return Visibility(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(false),
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              leading: _leading(provider, context),
              title: _title(provider, context),
              actions: actions.Actions(provider, context).build(),
            ),
            drawer: _drawer(provider, context),
            body: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.getDataListLength(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    if (provider.selectionMode) {
                      provider.changeSelected(index);
                    } else {
                      await provider.moveToAddView(context, index: index);
                    }
                  },
                  onLongPress: () {
                    if (!provider.selectionMode) provider.changeMode(true);
                    provider.changeSelected(index);
                  },
                  child: ListItem(
                    provider.selectedItems[index],
                    provider.getString(index, Notifications.titleKey),
                    provider.getInt(index, Notifications.setAlarmKey),
                    provider.getInt(index, Notifications.timeKey),
                  ),
                );
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _fab(provider, context),
          );
        },
      ),
    );
  }
}
