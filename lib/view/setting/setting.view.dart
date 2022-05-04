import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/color_picker/color_picker.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/main_provider.dart';
import 'package:reminder/provider/setting/theme_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';

// ignore: must_be_immutable
class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

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
      bottomNavigationBar: Consumer<MainProvider>(
        builder: (context, provider, child) => BottomNavigationBar(
          currentIndex: provider.index,
          onTap: (int index) {
            provider.changeIndex(index);
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
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Center(
        child: SizedBox(
          // height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Consumer<ThemeProvider>(
            builder: (context, provider, child) => ColorPicker(
              onPressed: (value, index) {
                provider.changeThemeColor(value);
              },
              columnCount: 4,
              colors: provider.colors,
              checkedItemIndex: provider.getIndex(),
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
              checkedItemIconSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
