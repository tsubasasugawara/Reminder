import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/view/search/search_bar/searchbar.dart';

import '../../components/brightness/brightness.dart';
import '../../provider/search/search_provider.dart';
import '../add_reminder/add_reminder_view.dart';
import '../home/list/list_item.dart';

// ignore: must_be_immutable
class SearchView extends StatelessWidget {
  late List<Map> dataList;
  late bool isTrash;

  SearchView(this.dataList, this.isTrash, {Key? key}) : super(key: key);

  Widget _fab(BuildContext context, SearchProvider provider) {
    return Visibility(
      visible: provider.isKeyboardShown,
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
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(dataList),
      builder: (context, child) {
        var provider = Provider.of<SearchProvider>(context);

        return Scaffold(
          appBar: SearchBar.generate(context),
          body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.displayDataList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // タップしても遷移できない
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return AddReminderView(
                          id: provider.displayDataList[index]["id"],
                          title: provider.displayDataList[index]["title"],
                          content: provider.displayDataList[index]["content"],
                          time: provider.displayDataList[index]["time"],
                          setAlarm: provider.displayDataList[index]["setAlarm"],
                          isTrash: isTrash,
                        );
                      },
                    ),
                  );
                },
                child: ListItem(
                  false,
                  provider.displayDataList[index]["title"],
                  provider.displayDataList[index]["setAlarm"],
                  provider.displayDataList[index]["time"],
                ),
              );
            },
          ),
          floatingActionButton: _fab(context, provider),
        );
      },
    );
  }
}
