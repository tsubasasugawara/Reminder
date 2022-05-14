import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/setting/deletion/deletion_provider.dart';

class DeletingReminder extends StatelessWidget {
  const DeletingReminder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Text(
            AppLocalizations.of(context)!.deletionSetting,
            style:
                Theme.of(context).textTheme.bodyText1?.apply(fontSizeDelta: 3),
          ),
        ),
        Center(
          child: Consumer<DeletionProvider>(
            builder: (context, deletionProvider, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: deletionProvider.getNotAutoDeletionState(),
                      onChanged: (state) {
                        if (state == null) return;
                        FocusManager.instance.primaryFocus?.unfocus();
                        deletionProvider.changeNotAutoDeletionValue(state);
                        deletionProvider.changeAutoDeletionValue(!state);
                      },
                    ),
                    Text(
                      "自動で削除しない",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: deletionProvider.getAutoDeletionState(),
                      onChanged: (state) {
                        if (state == null) return;
                        if (state) {
                          deletionProvider.dayToDeleteFocusNode.requestFocus();
                        }
                        deletionProvider.changeNotAutoDeletionValue(!state);
                        deletionProvider.changeAutoDeletionValue(state);
                      },
                    ),
                    Text(
                      "アラームがオフになってから",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height:
                          Theme.of(context).textTheme.bodyText1!.fontSize! + 20,
                      width:
                          Theme.of(context).textTheme.bodyText1!.fontSize! + 20,
                      child: TextFormField(
                        focusNode: deletionProvider.dayToDeleteFocusNode,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.apply(fontSizeDelta: 10),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "日後に削除",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
