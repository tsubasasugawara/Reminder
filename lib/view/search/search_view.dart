import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:reminder/view/search/search_bar.dart';

import '../../utils/brightness/brightness.dart';
import '../../model/db/notifications.dart';
import '../../provider/search/search_provider.dart';
import '../add_reminder/add_reminder_view.dart';
import '../home/list/list_item.dart';

// ignore: must_be_immutable
class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  Widget _fab(BuildContext context) {
    return Visibility(
      visible: context.read(searchProvider).isKeyboardShown,
      child: FloatingActionButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Icon(
          Icons.keyboard_hide_outlined,
          size: 40,
          color: judgeBlackWhite(Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar.generate(context),
      body: Consumer(builder: (context, ref, child) {
        var displayDataList = ref.watch(searchProvider).displayDataList;

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: displayDataList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                // タップしても遷移できない
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AddReminderView(
                        id: displayDataList[index][Notifications.idKey],
                        title: displayDataList[index][Notifications.titleKey],
                        content: displayDataList[index]
                            [Notifications.contentKey],
                        time: displayDataList[index][Notifications.timeKey],
                        setAlarm: displayDataList[index]
                            [Notifications.setAlarmKey],
                        frequency: displayDataList[index]
                            [Notifications.frequencyKey],
                        isTrash: ref.read(searchProvider).isTrash,
                      );
                    },
                  ),
                );
              },
              child: ListItem(
                false,
                displayDataList[index][Notifications.titleKey],
                displayDataList[index][Notifications.setAlarmKey],
                displayDataList[index][Notifications.timeKey],
              ),
            );
          },
        );
      }),
      floatingActionButton: _fab(context),
    );
  }
}
