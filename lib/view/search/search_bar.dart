import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../provider/search/search_provider.dart';

class SearchBar {
  static PreferredSizeWidget generate(BuildContext context) {
    context.read(searchProvider).isKeyboardShown =
        0 < MediaQuery.of(context).viewInsets.bottom;

    return AppBar(
      title: TextField(
        autofocus: true,
        style: Theme.of(context).textTheme.titleLarge,
        controller: context.read(searchProvider).controller,
        focusNode: context.read(searchProvider).focusNode,
        onChanged: (str) {
          context.read(searchProvider.notifier).search(str);
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
            context.read(searchProvider).controller.clear();
            context.read(searchProvider.notifier).search("");
          },
        )
      ],
    );
  }
}
