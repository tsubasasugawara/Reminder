import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

import '../../../provider/home/appBar/top_up_set_alarm_provider.dart';

// ignore: must_be_immutable
class TopUpSetAlarmButton extends StatelessWidget {
  late Function onPressed;
  // アラームのオンオフで順番を決めるかどうか
  late bool topUp;

  TopUpSetAlarmButton(this.onPressed, this.topUp, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => TopUpSetAlarmButtonProvider(topUp),
      child: Consumer<TopUpSetAlarmButtonProvider>(
        builder: (context, provider, child) {
          return TextButton(
            onPressed: () {
              onPressed();
              provider.changeTopUp();
            },
            style: TextButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            child: (provider.topUp)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.topUpSetAlarmReminder,
                        style: Theme.of(context).textTheme.bodyText1?.apply(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  )
                : Text(
                    AppLocalizations.of(context)!.topUpSetAlarmReminder,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
          );
        },
      ),
    );
  }
}
