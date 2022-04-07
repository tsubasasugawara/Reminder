import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home_provider.dart';
import 'package:reminder/values/colors.dart';
import 'package:reminder/view/add_reminder_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

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
      body: Center(child: list(context)),
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
      create: (context) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          provider.getData();
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.model.dataList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  var dataList = provider.model.dataList;
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
                child: Container(
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
                  margin: const EdgeInsets.only(bottom: 20, left: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 10,
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
                                  provider.dateTimeFormat(
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
                            await provider.deleteData(index);
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
          );
        },
      ),
    );
  }
}
