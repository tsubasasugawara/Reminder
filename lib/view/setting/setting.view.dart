import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/color_picker/color_picker.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/setting/theme_provider.dart';

// ignore: must_be_immutable
class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    AppLocalizations.of(context)!.uiModeSetting,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.apply(fontSizeDelta: 3),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Consumer<ThemeProvider>(
                      builder: (context, provider, child) => ColorPicker(
                        onPressed: (value, index) {
                          provider.changeUiMode(value);
                        },
                        columnCount: 4,
                        colors: const [
                          0xffffffff,
                          0xff000000,
                        ],
                        checkedItemIndex: provider.getUiModeIndex(),
                        mainAxisSpacing: 25,
                        crossAxisSpacing: 25,
                        checkedItemIconSize: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).hintColor,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    AppLocalizations.of(context)!.colorSetting,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.apply(fontSizeDelta: 3),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.8,
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
              ],
            ),
            Divider(
              color: Theme.of(context).hintColor,
            ),
          ],
        ),
      ),
    );
  }
}
