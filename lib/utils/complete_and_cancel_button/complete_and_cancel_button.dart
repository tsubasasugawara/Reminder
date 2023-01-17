import 'package:flutter/material.dart';

import '../../multilingualization/app_localizations.dart';

// ignore: must_be_immutable
class CompleteAndCancelButton extends StatelessWidget {
  late Function okAction;
  late Function cancelAction;

  CompleteAndCancelButton(this.okAction, this.cancelAction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () async {
            await okAction();
          },
          child: Text(
            AppLocalizations.of(context)!.cancelButton,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        TextButton(
          onPressed: () async {
            await cancelAction();
          },
          child: Text(
            AppLocalizations.of(context)!.ok,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
