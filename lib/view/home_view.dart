import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/provider/home_provider.dart';
import 'package:reminder/view/add_reminder_view.dart';

class HomeView extends StatelessWidget {
  final String title = "Reminder";

  const HomeView({Key? key}) : super(key: key);

  static var textColor = const Color.fromARGB(255, 208, 208, 208);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
            color: textColor,
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
    return Consumer<HomeProvider>(
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
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.model.dataList[index]['title'],
                            style: TextStyle(
                              color: textColor,
                              fontSize: 24,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              provider.dateTimeFormat(
                                provider.model.dataList[index]['time'],
                              ),
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
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
    );
  }
}
