import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/color_picker/color_picker.dart';
import 'package:reminder/provider/setting/theme_provider.dart';

// ignore: must_be_immutable
class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
