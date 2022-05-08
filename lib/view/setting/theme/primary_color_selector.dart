import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/color_picker/color_picker.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';
import 'package:reminder/view/setting/theme/rgb_edior.dart';

class PrimaryColorSelector extends StatelessWidget {
  const PrimaryColorSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Text(
            AppLocalizations.of(context)!.colorSetting,
            style:
                Theme.of(context).textTheme.bodyText1?.apply(fontSizeDelta: 3),
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
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: const RGBEditor(),
          ),
        ),
      ],
    );
  }
}
