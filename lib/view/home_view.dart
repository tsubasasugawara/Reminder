import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/button/form_control_button.dart';
import 'package:reminder/components/button/list_control_button.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/check_box_provider.dart';
import 'package:reminder/provider/home/home_list_provider.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/values/colors.dart';
import 'package:reminder/view/add_reminder_view.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  HomeProvider provider = HomeProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: const TextStyle(color: AppColors.textColor),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
            color: AppColors.textColor,
          ),
        ],
      ),
      body: Center(
        child: Expanded(
          child: list(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReminderView(null, null, null, null),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget list(context) {
    return ChangeNotifierProvider(
      create: (context) => HomeListProvider(),
      child: Consumer<HomeListProvider>(
        builder: (context, homeListProvider, child) {
          homeListProvider.getData();
          return Column(
            children: [
              Visibility(
                visible: provider.checkBoxVisible,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListControlButton(
                        AppLocalizations.of(context)!.cancelButton,
                        Colors.red,
                        () {
                          provider.checkBoxVisible = false;
                          provider.resetCheckedList();
                        },
                      ),
                      ListControlButton(
                        AppLocalizations.of(context)!.delete,
                        Colors.green,
                        () {
                          provider.delete();
                          provider.checkBoxVisible = false;
                          provider.resetCheckedList();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: homeListProvider.model.dataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Center(
                          child: Visibility(
                            visible: provider.checkBoxVisible,
                            child: ChangeNotifierProvider(
                              create: (BuildContext context) =>
                                  CheckBoxProvider(),
                              child: Consumer<CheckBoxProvider>(
                                builder: (context, checkBoxProvider, child) {
                                  checkBoxProvider.isChecked = provider
                                              .model.checkedList[
                                          homeListProvider.model.dataList[index]
                                              ["id"]] ??
                                      false;
                                  return Checkbox(
                                    value: checkBoxProvider.isChecked,
                                    onChanged: (bool? value) {
                                      checkBoxProvider.isChecked =
                                          value ?? false;
                                      homeListProvider.checkBox(
                                          provider.model.checkedList,
                                          homeListProvider.model.dataList[index]
                                              ["id"],
                                          value);
                                    },
                                    side: const BorderSide(
                                      color: Colors.green,
                                      width: 1,
                                    ),
                                    checkColor: Colors.black,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              var dataList = homeListProvider.model.dataList;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReminderView(
                                    dataList[index]["id"],
                                    dataList[index]["title"],
                                    dataList[index]["content"],
                                    dataList[index]["time"],
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              provider.checkBoxVisible = true;
                              homeListProvider.checkBox(
                                  provider.model.checkedList,
                                  homeListProvider.model.dataList[index]["id"],
                                  true);
                            },
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 20,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: Colors.green,
                                    width: 4,
                                    style: BorderStyle.solid,
                                  ),
                                  top: BorderSide(
                                    color: Color.fromARGB(255, 60, 60, 60),
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                  right: BorderSide(
                                    color: Color.fromARGB(255, 60, 60, 60),
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                  bottom: BorderSide(
                                    color: Color.fromARGB(255, 60, 60, 60),
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
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
                                          homeListProvider.model.dataList[index]
                                              ['title'],
                                          style: const TextStyle(
                                            color: AppColors.textColor,
                                            fontSize: 24,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: Text(
                                            homeListProvider.dateTimeFormat(
                                                homeListProvider.model
                                                    .dataList[index]['time'],
                                                context),
                                            style: const TextStyle(
                                              color: AppColors.textColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await homeListProvider.deleteData(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
