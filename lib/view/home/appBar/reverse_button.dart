import 'package:flutter/material.dart';
import 'package:reminder/model/db/db_env.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

// ignore: must_be_immutable
class ReverseOrderButton extends StatelessWidget {
  late Function onPressed;
  late String sortby;

  ReverseOrderButton(this.onPressed, this.sortby, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      style: TextButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: (DBEnv.desc == sortby)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.sortBy,
                  style: Theme.of(context).textTheme.bodyText1?.apply(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            )
          : Text(
              AppLocalizations.of(context)!.sortBy,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}
