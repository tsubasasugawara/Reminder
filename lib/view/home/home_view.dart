import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/utils/brightness/brightness.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';
import 'package:reminder/view/home/appBar/actions.dart' as actions;
import 'package:reminder/view/trash/trash.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../model/db/notifications.dart';
import '../setting/setting_view.dart';
import 'list/list_item.dart';

// ignore: must_be_immutable
class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  Widget? _leading(BuildContext context) {
    return context.read(homeProvider).selectionMode
        ? IconButton(
            icon: const Icon(Icons.close_sharp),
            onPressed: () {
              context
                  .read(homeProvider.notifier)
                  .changeMode(selectionMode: false);
            },
          )
        : null;
  }

  Widget _title(BuildContext context) {
    return context.read(homeProvider).selectionMode
        ? Text(
            "  " + context.read(homeProvider).selectedItemsCnt.toString(),
            style: Theme.of(context).textTheme.headline6,
          )
        : Text(
            AppLocalizations.of(context)!.appTitle,
            style: Theme.of(context).textTheme.headline6,
          );
  }

  Widget _drawer(BuildContext context) {
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
              context.read(homeProvider.notifier).update();
              context.read(homeProvider.notifier).allSelectOrNot(false);
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
              context.read(homeProvider.notifier).update();
              context.read(homeProvider.notifier).allSelectOrNot(false);
            },
          ),
        ],
      ),
    );
  }

  Widget? _fab(BuildContext context) {
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
          context.read(homeProvider.notifier).update();
          context.read(homeProvider.notifier).allSelectOrNot(false);
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
    // TODO:変更する必要のないところまで更新してしまっている
    return Consumer(
      builder: (context, ref, child) {
        var dataList = ref.watch(homeProvider).dataList;
        var selectionMode = ref.watch(homeProvider).selectionMode;
        var selectedItems = ref.watch(homeProvider).selectedItems;

        return Scaffold(
          appBar: AppBar(
            leading: _leading(context),
            title: _title(context),
            actions: actions.Actions(context, ref).build(),
          ),
          drawer: _drawer(context),
          body: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            displacement: 40,
            onRefresh: () async {
              await ref.read(homeProvider.notifier).setData();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: ref.read(homeProvider).dataList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    if (selectionMode) {
                      ref.read(homeProvider.notifier).changeSelected(index);
                    } else {
                      await ref
                          .read(homeProvider.notifier)
                          .moveToAddView(context, index: index);
                    }
                  },
                  onLongPress: () {
                    if (!selectionMode) {
                      ref
                          .read(homeProvider.notifier)
                          .changeMode(selectionMode: true);
                    }
                    ref.read(homeProvider.notifier).changeSelected(index);
                  },
                  child: ListItem(
                    selectedItems[index],
                    dataList[index][Notifications.titleKey],
                    dataList[index][Notifications.setAlarmKey],
                    dataList[index][Notifications.timeKey],
                  ),
                );
              },
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _fab(context),
        );
      },
    );
  }
}
