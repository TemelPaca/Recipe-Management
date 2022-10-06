import 'package:flutter/material.dart';
import 'package:recipe_management/utilities/dialogs/generic_dialog.dart';

Future<bool> showDiscardChangesDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'One or more parameter is out of range !',
    content: 'Do you want to discard changes ?',
    optionsBuilder: () => {'Yes': true, 'Cancel': false},
  ).then((value) => value ?? false);
}
