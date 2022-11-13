import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/brightness/brightness.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';

class UiModeSelector extends StatelessWidget {
  const UiModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Text(
            AppLocalizations.of(context)!.uiModeSetting,
            style:
                Theme.of(context).textTheme.bodyText1?.apply(fontSizeDelta: 3),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            width: MediaQuery.of(context).size.width,
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      themeProvider.changeUiMode("L");
                    },
                    icon: Icon(
                      themeProvider.uiMode == "L"
                          ? Icons.wb_sunny
                          : Icons.wb_sunny_outlined,
                      color: judgeBlackWhite(
                        Theme.of(context).backgroundColor,
                      ),
                    ),
                    iconSize: 60,
                  ),
                  IconButton(
                    onPressed: () {
                      themeProvider.changeUiMode("D");
                    },
                    icon: Icon(
                      themeProvider.uiMode == "D"
                          ? Icons.mode_night
                          : Icons.mode_night_outlined,
                      color: judgeBlackWhite(
                        Theme.of(context).backgroundColor,
                      ),
                    ),
                    iconSize: 60,
                  ),
                  IconButton(
                    onPressed: () {
                      themeProvider.changeUiMode("A");
                    },
                    icon: Icon(
                      themeProvider.uiMode == "A"
                          ? Icons.brightness_auto
                          : Icons.brightness_auto_outlined,
                      color: judgeBlackWhite(
                        Theme.of(context).backgroundColor,
                      ),
                    ),
                    iconSize: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
