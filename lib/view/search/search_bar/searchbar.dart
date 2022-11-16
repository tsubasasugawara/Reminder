import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

import '../../../provider/search/search_provider.dart';

class SearchBar {
  static PreferredSizeWidget generate(BuildContext context) {
    var provider = Provider.of<SearchProvider>(context);
    provider.isKeyboardShown = 0 < MediaQuery.of(context).viewInsets.bottom;

    return AppBar(
      title: TextField(
        autofocus: true,
        style: Theme.of(context).textTheme.headline6,
        controller: provider.controller,
        focusNode: provider.focusNode,
        onChanged: (str) {
          provider.search(str);
        },
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: InputBorder.none,
          hintText: AppLocalizations.of(context)!.searchBarHintText,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            provider.controller.clear();
            provider.search("");
          },
        )
      ],
    );
  }
}
