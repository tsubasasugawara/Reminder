import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/home_provider.dart';
import 'package:reminder/provider/main_provider.dart';
import 'package:reminder/view/home/home_list.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  MainProvider mainProvider;
  HomeView(this.mainProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => HomeProvider()),
      child: Consumer<HomeProvider>(
        builder: ((context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.appTitle,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            body: HomeList(provider),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await provider.moveToAddView(context);
              },
              child: Icon(
                Icons.add,
                size: 30,
                color: Theme.of(context).backgroundColor,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: mainProvider.index,
              onTap: (int index) {
                mainProvider.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.home,
                  ),
                  label: AppLocalizations.of(context)!.home,
                ),
                BottomNavigationBarItem(
                    icon: const Icon(
                      Icons.settings,
                    ),
                    label: AppLocalizations.of(context)!.setting),
              ],
            ),
          );
        }),
      ),
    );
  }
}
