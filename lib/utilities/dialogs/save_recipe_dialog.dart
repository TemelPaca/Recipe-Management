import 'package:flutter/material.dart';
import 'package:recipe_management/entities.dart';
import 'package:recipe_management/utilities/dialogs/generic_dialog.dart';

Future<bool> showSaveRecipeDialog(BuildContext context, Recipe? recipe) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Save Confirmation',
    content: 'Do you really want to save ${recipe?.name} ?  ',
    optionsBuilder: () => {'Yes': true, 'Cancel': false},
  ).then((value) => value ?? false);
}
