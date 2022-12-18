import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                Theme.of(context).textTheme.bodyText1?.apply(fontSizeDelta: 3),
          ),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => AutoDeleteProvider(),
          child: Consumer<AutoDeleteProvider>(
            builder: (context, provider, child) {
              return FutureBuilder(
                future: Provider.of<AutoDeleteProvider>(context).init(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Column(
                    children: [
                      Center(
                        child: CheckboxListTile(
                          value: provider.checkBoxCondition,
                          title: Text(
                            AppLocalizations.of(context)!.automaticDeleteMsg,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) async {
                            await provider.onChangeCheckBox(value);
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
                              enabled: provider.checkBoxCondition,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              controller: provider.controller,
                              style: Theme.of(context).textTheme.bodyText1,
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
                                provider.onChangeTextField(value);
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: Text(
                              provider.controller.text == "1"
                                  ? AppLocalizations.of(context)!.dayLater
                                  : AppLocalizations.of(context)!.daysLater,
                              style: Theme.of(context).textTheme.bodyText1,
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
        ),
      ],
    );
  }
}
