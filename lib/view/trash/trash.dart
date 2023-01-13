import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/utils/snack_bar/snackbar.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/view/home/appBar/actions.dart' as actions;

import '../../model/db/notifications.dart';

// ignore: must_be_immutable
class Trash extends StatelessWidget {
  const Trash({Key? key}) : super(key: key);

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
            AppLocalizations.of(context)!.trash,
            style: Theme.of(context).textTheme.headline6,
          );
  }

  List<Widget>? _actions(HomeProvider provider, BuildContext context) {
    return provider.selectionMode
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
                      context,
                      HomeProvider.restoreFromTrash,
                    );
                    if (res) {
                      ShowSnackBar(
                        context,
                        AppLocalizations.of(context)!.restoreReminderToTrash,
                        Theme.of(context).primaryColor,
                      );
                    }
                  },
                  icon: const Icon(Icons.restore_from_trash),
                ),
                IconButton(
                  onPressed: () async {
                    var res = await provider.deleteButton(
                        context, HomeProvider.completeDeletion);
                    if (res) {
                      ShowSnackBar(
                        context,
                        AppLocalizations.of(context)!.deletedReminder,
                        Theme.of(context).primaryColor,
                      );
                    }
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
              ],
            ),
          ]
        : actions.Actions(provider, context).build();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(true),
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) => Scaffold(
          appBar: AppBar(
            leading: _leading(provider, context),
            title: _title(provider, context),
            actions: _actions(provider, context),
          ),
          body: Center(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.getDataListLength(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    if (provider.selectionMode) {
                      provider.changeSelected(index);
                    } else {
                      await provider.moveToAddView(
                        context,
                        index: index,
                        isTrash: provider.isTrash,
                      );
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
                                    provider.getString(
                                        index, Notifications.titleKey),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.apply(
                                          fontSizeDelta: 6,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
}
