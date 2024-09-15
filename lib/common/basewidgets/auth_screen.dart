
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';

Future<bool> exitAppConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(getTranslated('exit_confirmation', context)!),
      content: Text(getTranslated('are_you_sure_you_want_to_exit', context)!),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(getTranslated('cancel', context)!),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(getTranslated('exit', context)!),
        ),
      ],
    ),
  ) ?? false;
}
