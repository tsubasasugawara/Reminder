import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/view/setting/theme/primary_color_selector.dart';
import 'package:reminder/view/setting/theme/ui_mode_selector.dart';
import 'package:reminder/components/spacer/spacer.dart' as spacer;

// ignore: must_be_immutable
class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  final double _verticalSpaceSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.setting,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            top: 20,
            bottom: 50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UiModeSelector(),
              spacer.Spacer(_verticalSpaceSize, _verticalSpaceSize, 0, 0),
              const PrimaryColorSelector(),
              spacer.Spacer(_verticalSpaceSize, _verticalSpaceSize, 0, 0),
            ],
          ),
        ),
      ),
    );
  }
}