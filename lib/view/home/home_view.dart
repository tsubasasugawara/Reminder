import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/brightness/brightness.dart';
import 'package:reminder/components/snack_bar/snackbar.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/db/notifications.dart';
import 'package:reminder/model/kotlin_method_calling/kotlin_method_calling.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';
import 'package:reminder/view/trash/trash.dart';

import '../setting/setting_view.dart';

// ignore: must_be_immutable
class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(false),
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) => Scaffold(
          appBar: AppBar(
            leading: provider.selectionMode
                ? IconButton(
                    icon: const Icon(Icons.close_sharp),
                    onPressed: () {
                      provider.changeMode(false);
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.close_sharp),
                    onPressed: () async {
                      var nt = Notifications();
                      print(await nt.select({"1": "*"}).runtimeType);
                    },
                  ),
            title: provider.selectionMode
                ? Text(
                    "  " +
                        Provider.of<HomeProvider>(context)
                            .selectedItemsCnt
                            .toString(),
                    style: Theme.of(context).textTheme.headline6,
                  )
                : Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search Flutter Topic",
                            hintStyle: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (String keyword) {},
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Theme.of(context).hintColor,
                      )
                    ],
                  ),
            // Text(
            //     AppLocalizations.of(context)!.appTitle,
            //     style: Theme.of(context).textTheme.headline6,
            //   ),
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
                            var res = await provider.deleteButton(
                                context, HomeProvider.moveToTrash);
                            if (res) {
                              ShowSnackBar(
                                context,
                                AppLocalizations.of(context)!
                                    .moveReminderToTrash,
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
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const SettingView();
                        },
                      ),
                    );
                    Navigator.pop(context);
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
                          return const Trash();
                        },
                      ),
                    );
                    Navigator.pop(context);
                    provider.update();
                    provider.allSelectOrNot(false);
                  },
                ),
              ],
            ),
          ),
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
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(
                        color: provider.selectedItems[index]
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).hintColor,
                        width: provider.selectedItems[index] ? 2.5 : 1.5,
                      ),
                      color: Theme.of(context).backgroundColor,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.getString(index, "title"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.apply(
                                        fontSizeDelta: 6,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    provider.alarmOnOff(index, context),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: provider.getInt(index,
                                        NotificationsTable.setAlarmKey) ==
                                    1
                                ? Icon(
                                    Icons.alarm_on,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : Icon(
                                    Icons.alarm_off,
                                    color: Theme.of(context).hintColor,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
      ),
    );
  }
}
