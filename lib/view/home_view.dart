import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home_list_provider.dart';
import 'package:reminder/values/colors.dart';
import 'package:reminder/view/add_reminder_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeListProvider(),
      child: Consumer<HomeListProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                AppLocalizations.of(context)!.appTitle,
                style: const TextStyle(color: AppColors.textColor),
              ),
            ),
            body: Center(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: provider.model.dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      var dataList = provider.model.dataList;
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return AddReminderView(
                              dataList[index]["id"],
                              dataList[index]["title"],
                              dataList[index]["content"],
                              dataList[index]["time"],
                              dataList[index]["setAlarm"],
                            );
                          },
                        ),
                      );
                      provider.getData();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        gradient: LinearGradient(
                          stops: const [0.02, 0.02],
                          colors: [
                            provider.model.dataList[index]["setAlarm"] == 1
                                ? Colors.green
                                : Colors.red,
                            AppColors.listBackground,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 20, left: 5),
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
                                    provider.model.dataList[index]['title'],
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
                                      provider.alarmOnOff(
                                          provider.model.dataList[index]
                                              ["setAlarm"],
                                          provider.model.dataList[index]
                                              ['time'],
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
                                provider.deleteFromDbAndAlarm(
                                  index,
                                  () {
                                    provider.getData();
                                  },
                                );
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
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AddReminderView(null, null, null, null, null);
                    },
                  ),
                );
                provider.getData();
              },
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black,
              ),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}
