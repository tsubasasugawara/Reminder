import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/utils/brightness/brightness.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';
import 'package:reminder/utils/spacer/spacer.dart' as spacer;

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
                Theme.of(context).textTheme.bodyLarge?.apply(fontSizeDelta: 3),
          ),
        ),
        spacer.Spacer(20, 0, 0, 0),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Consumer(
              builder: (context, ref, child) {
                var uiMode = ref.watch(themeProvider).uiMode;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        ref
                            .read(themeProvider.notifier)
                            .changeUiMode(ThemeProviderData.lightTheme);
                      },
                      icon: Icon(
                        uiMode == ThemeProviderData.lightTheme
                            ? Icons.wb_sunny
                            : Icons.wb_sunny_outlined,
                        color: judgeBlackWhite(
                          Theme.of(context).colorScheme.background,
                        ),
                      ),
                      iconSize: 60,
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(themeProvider.notifier)
                            .changeUiMode(ThemeProviderData.darkTheme);
                      },
                      icon: Icon(
                        uiMode == ThemeProviderData.darkTheme
                            ? Icons.mode_night
                            : Icons.mode_night_outlined,
                        color: judgeBlackWhite(
                          Theme.of(context).colorScheme.background,
                        ),
                      ),
                      iconSize: 60,
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(themeProvider.notifier)
                            .changeUiMode(ThemeProviderData.auto);
                      },
                      icon: Icon(
                        uiMode == ThemeProviderData.auto
                            ? Icons.brightness_auto
                            : Icons.brightness_auto_outlined,
                        color: judgeBlackWhite(
                          Theme.of(context).colorScheme.background,
                        ),
                      ),
                      iconSize: 60,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
