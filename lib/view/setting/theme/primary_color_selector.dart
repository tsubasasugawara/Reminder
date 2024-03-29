import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/view/setting/theme/color_picker.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';

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
                Theme.of(context).textTheme.bodyLarge?.apply(fontSizeDelta: 3),
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Consumer(
              builder: (context, ref, child) => ColorPicker(
                onPressed: (value, index) {
                  ref.read(themeProvider.notifier).changePrimaryColor(value);
                },
                columnCount: 4,
                colors: ref.read(themeProvider).colors,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                checkedItemIconSize: 30,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
