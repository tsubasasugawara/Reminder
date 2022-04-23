import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/main_provider.dart';
import 'package:reminder/values/colors.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';

// ignore: must_be_immutable
class SettingView extends StatelessWidget {
  MainProvider mainProvider;
  SettingView(this.mainProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.setting,
          style: const TextStyle(color: AppColors.textColor),
        ),
      ),
      body: Container(),
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
        child: const Icon(
          Icons.add,
          size: 30,
          color: AppColors.backgroundColor,
        ),
        backgroundColor: AppColors.mainColor,
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
}
