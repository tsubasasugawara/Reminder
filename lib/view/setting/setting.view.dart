import 'package:flutter/material.dart';
import 'package:reminder/components/color_picker/color_picker.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/main_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';

// ignore: must_be_immutable
class SettingView extends StatelessWidget {
  MainProvider mainProvider;
  List<int> colors = [
    0xffc0c0c0,
    0xff0000ff,
    0xff00ff00,
    0xffff0000,
    0xffffe4b5,
    0xff00ffff,
    0xffffff00,
    0xffff00ff,
    0xffa52a2a,
    0xff4169e1,
    0xffffa500,
    0xff9400d3,
  ];
  SettingView(this.mainProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.setting,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: _body(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddReminderView();
              },
            ),
          );
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
            label: AppLocalizations.of(context)!.setting,
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.7,
          child: ColorPicker(
            onPressed: (value, index) {
              print(value);
              print(index);
            },
            columnCount: 4,
            colors: colors,
            checkedItemIndex: 0,
            mainAxisSpacing: 25,
            crossAxisSpacing: 25,
            checkedItemIconSize: 30,
          ),
        ),
      ),
    );
  }
}
