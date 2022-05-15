import 'package:flutter/material.dart';
import 'package:reminder/components/brightness.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class DeletionConfirmationDialog extends StatelessWidget {
  const DeletionConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.confirmation),
      content: Text(AppLocalizations.of(context)!.confirmationMsg),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(
              width: 1.0,
              color: Theme.of(context).hintColor,
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.cancelButton,
            style: TextStyle(
              color: judgeBlackWhite(Theme.of(context).backgroundColor),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(
              width: 1.0,
              color: Theme.of(context).hintColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              AppLocalizations.of(context)!.ok,
              style: TextStyle(
                color: judgeBlackWhite(Theme.of(context).backgroundColor),
              ),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
