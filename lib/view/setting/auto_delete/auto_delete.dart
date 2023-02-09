import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

import '../../../provider/setting/auto_delete/auto_delete_provider.dart';

class AutoRemove extends StatelessWidget {
  const AutoRemove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Text(
            AppLocalizations.of(context)!.automaticDelete,
            style:
                Theme.of(context).textTheme.bodyLarge?.apply(fontSizeDelta: 3),
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            return FutureBuilder(
              future: ref.read(autoDeletionProvider.notifier).init(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Column(
                  children: [
                    Center(
                      child: CheckboxListTile(
                        value:
                            ref.watch(autoDeletionProvider).checkBoxCondition,
                        title: Text(
                          AppLocalizations.of(context)!.automaticDeleteMsg,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) async {
                          await ref
                              .read(autoDeletionProvider.notifier)
                              .onChangeCheckBox(value);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          // TODO: 繰り返しの間隔設定も同じフォームを使用するため、共通化
                          child: TextField(
                            enabled: ref
                                .watch(autoDeletionProvider)
                                .checkBoxCondition,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            controller:
                                ref.watch(autoDeletionProvider).controller,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                            ),
                            onChanged: (value) async {
                              ref
                                  .read(autoDeletionProvider.notifier)
                                  .onChangeTextField(value);
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Text(
                            ref.watch(autoDeletionProvider).controller.text ==
                                    "1"
                                ? AppLocalizations.of(context)!.dayLater
                                : AppLocalizations.of(context)!.daysLater,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
