import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/provider/home/home_provider.dart';

// ignore: must_be_immutable
class HomeList extends StatelessWidget {
  const HomeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) => Center(
        child: RefreshIndicator(
          onRefresh: () async {
            await provider.update();
          },
          color: Theme.of(context).backgroundColor,
          backgroundColor: Theme.of(context).primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.getDataListLength(),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  await provider.moveToAddView(context, index: index);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(
                        color: Theme.of(context).hintColor,
                        width: 1.5,
                      ),
                      color: Theme.of(context).backgroundColor,
                      // color: Color.fromARGB(255, 55, 55, 55),
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
                          IconButton(
                            onPressed: () async {
                              provider.deleteButton(context, index);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).hintColor,
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
      ),
    );
  }
}
