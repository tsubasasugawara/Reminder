import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/utils/snack_bar/snackbar.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/view/home/appBar/actions.dart' as actions;
import 'package:riverpod_context/riverpod_context.dart';

import '../../model/db/notifications.dart';

final trashProvider =
    StateNotifierProvider<HomeProvider, Home>((ref) => HomeProvider(true));

// ignore: must_be_immutable
class Trash extends StatelessWidget {
  const Trash({Key? key}) : super(key: key);

  Widget? _leading(BuildContext context) {
    return context.read(trashProvider).selectionMode
        ? IconButton(
            icon: const Icon(Icons.close_sharp),
            onPressed: () {
              context
                  .read(trashProvider.notifier)
                  .changeMode(selectionMode: false);
            },
          )
        : null;
  }

  Widget _title(BuildContext context) {
    return context.read(trashProvider).selectionMode
        ? Text(
            "  " + context.read(trashProvider).selectedItemsCnt.toString(),
            style: Theme.of(context).textTheme.titleLarge,
          )
        : Text(
            AppLocalizations.of(context)!.trash,
            style: Theme.of(context).textTheme.titleLarge,
          );
  }

  List<Widget>? _actions(BuildContext context, WidgetRef ref) {
    return context.read(trashProvider).selectionMode
        ? [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read(trashProvider.notifier).allSelectOrNot(true);
                  },
                  icon: const Icon(Icons.select_all),
                ),
                IconButton(
                  onPressed: () async {
                    var res =
                        await context.read(trashProvider.notifier).deleteButton(
                              context,
                              Home.restoreFromTrash,
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
                    var res = await context
                        .read(trashProvider.notifier)
                        .deleteButton(context, Home.completeDeletion);
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
        : actions.Actions(context, ref).build();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read(trashProvider.notifier).setData(),
        builder: (context, snapshot) {
          return Consumer(
            builder: (context, ref, child) {
              var dataList = ref.watch(trashProvider).dataList;
              var selectionMode = ref.watch(trashProvider).selectionMode;
              var selectedItems = ref.watch(trashProvider).selectedItems;

              return Scaffold(
                appBar: AppBar(
                  leading: _leading(context),
                  title: _title(context),
                  actions: _actions(context, ref),
                ),
                body: Center(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          if (selectionMode) {
                            ref
                                .read(trashProvider.notifier)
                                .changeSelected(index);
                          } else {
                            await ref
                                .read(trashProvider.notifier)
                                .moveToAddView(
                                  context,
                                  index: index,
                                  isTrash: ref.read(trashProvider).isTrash,
                                );
                          }
                        },
                        onLongPress: () {
                          if (!selectionMode) {
                            ref
                                .read(trashProvider.notifier)
                                .changeMode(selectionMode: true);
                          }
                          ref
                              .read(trashProvider.notifier)
                              .changeSelected(index);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              border: Border.all(
                                color: selectedItems[index]
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).hintColor,
                                width: selectedItems[index] ? 2.5 : 1.5,
                              ),
                              color: Theme.of(context).colorScheme.background,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dataList[index]
                                              [Notifications.titleKey],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
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
              );
            },
          );
        });
  }
}
