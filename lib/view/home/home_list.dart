import 'package:flutter/material.dart';
import 'package:reminder/provider/home/home_provider.dart';

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
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).backgroundColor,
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
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Color.fromARGB(255, 55, 55, 55),
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
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ],
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
    );
  }
}
