import 'package:flutter/material.dart';
import 'package:reminder/view/setting/theme/primary_color_selector.dart';
import 'package:reminder/view/setting/theme/ui_mode_selector.dart';

// ignore: must_be_immutable
class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(
          top: 20,
          bottom: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UiModeSelector(),
            Divider(
              color: Theme.of(context).hintColor,
            ),
            const PrimaryColorSelector(),
            Divider(
              color: Theme.of(context).hintColor,
            ),
          ],
        ),
      ),
    );
  }
}
