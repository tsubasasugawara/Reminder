import 'package:flutter/material.dart';
import 'package:reminder/values/messages.dart';

class AppLocalizations {
  final Messages messages;

  AppLocalizations(Locale locale) : messages = Messages.of(locale);

  static Messages? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)
        ?.messages;
  }
}
