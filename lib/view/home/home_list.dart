import 'package:flutter/material.dart';
import 'package:reminder/components/snack_bar/snackbar.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/values/colors.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';

// ignore: must_be_immutable
class HomeList extends StatelessWidget {
  HomeProvider provider;
  HomeList(this.provider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          await provider.update();
        },
        backgroundColor: AppColors.backgroundColor,
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
                        dataList[index]["set_alarm"],
                      );
                    },
                  ),
                );
                provider.getData();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.listBackground,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
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
                                          ["set_alarm"],
                                      provider.model.dataList[index]['time'],
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
                            var res = await provider.deleteFromDbAndAlarm(
                              index,
                              () {
                                provider.getData();
                              },
                            );
                            if (res) {
                              ShowSnackBar(
                                context,
                                AppLocalizations.of(context)!.deletedAlarm,
                                AppColors.error,
                              );
                            }
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
            );
          },
        ),
      ),
    );
  }
}
