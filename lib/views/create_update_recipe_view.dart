import 'package:flutter/material.dart';
import 'package:recipe_management/entities.dart';
import 'package:recipe_management/generics/get_arguments.dart';
import 'package:recipe_management/services/objectbox/crud.dart';
import 'package:recipe_management/utilities/decorations/text_form_field_decorations.dart';
import 'package:recipe_management/utilities/dialogs/discard_changes_dialog.dart';
import 'package:recipe_management/utilities/dialogs/save_recipe_dialog.dart';
import 'package:recipe_management/utilities/text_validation/empty_string_input_validation.dart';
import 'package:recipe_management/utilities/text_validation/numeric_data_input_validation.dart';
import 'package:recipe_management/widgets/machine_operator_dropdown.dart';

class CreateUpdateRecipeView extends StatefulWidget {
  const CreateUpdateRecipeView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateRecipeView> createState() => _CreateUpdateRecipeViewState();
}

class _CreateUpdateRecipeViewState extends State<CreateUpdateRecipeView> {
  late ObjectBox _objectBox;
  late TextEditingController _recipeNameController;
  late TextEditingController _recipeCountController;
  late TextEditingController _recipeTemperatureController;
  late TextEditingController _recipeSpeedController;

  Recipe? _tempRecipe;
  MachineOperator? _machineOperator;
  int? _id;
  String? _name;
  int? _count;
  double? _temperature;
  double? _speed;
  bool _firstScan = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _recipeNameController = TextEditingController();
    _recipeCountController = TextEditingController();
    _recipeTemperatureController = TextEditingController();
    _recipeSpeedController = TextEditingController();
    _firstScan = true;
    super.initState();
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _recipeCountController.dispose();
    _recipeTemperatureController.dispose();
    _recipeSpeedController.dispose();
    super.dispose();
  }

  void _saveRecipe(Recipe recipe) {
    _objectBox.createNewRecipe(recipe);
  }

  void _placeRecipeData() {
    _recipeNameController.text = _name ?? _recipeNameController.text;
    _recipeCountController.text =
        _count == null ? _recipeCountController.text : _count.toString();
    _recipeTemperatureController.text =
        _temperature?.toStringAsFixed(2) ?? _recipeTemperatureController.text;
    _recipeSpeedController.text =
        _speed?.toStringAsFixed(2) ?? _recipeSpeedController.text;
  }

  @override
  Widget build(BuildContext context) {
    var args = context.getArgument<Object>() as List;
    _objectBox = args[1] as ObjectBox;
    if (_firstScan == true) {
      if (args[0] != null) {
        _id = (args[0] as Recipe).id;
        _machineOperator = (args[0] as Recipe).machineOperator.target;
        _name = (args[0] as Recipe).name;
        _count = (args[0] as Recipe).count;
        _temperature = (args[0] as Recipe).temperature;
        _speed = (args[0] as Recipe).speed;
        _tempRecipe = Recipe(
          id: _id!,
          name: _name!,
          temperature: _temperature!,
          speed: _speed!,
          count: _count!,
        );

        _tempRecipe?.machineOperator.target = _machineOperator;
      }
      _placeRecipeData();
      _firstScan = false;
    }

    var machineOperatorStream = _objectBox.readAllMachineOperator();

    return WillPopScope(
      onWillPop: () async {
        if (_formKey.currentState!.validate() && (_machineOperator != null)) {
          var recipe = Recipe(
            id: _id ?? 0,
            name: _recipeNameController.text,
            temperature: double.tryParse(_recipeTemperatureController.text)!,
            speed: double.tryParse(_recipeSpeedController.text)!,
            count: int.tryParse(_recipeCountController.text)!,
          );
          recipe.machineOperator.target = _machineOperator;
          if (recipe != _tempRecipe) {
            bool shouldSave = await showSaveRecipeDialog(context, recipe);
            if (shouldSave) {
              _saveRecipe(recipe);
            }
          }
          return true;
        } else {
          bool shouldDiscard = await showDiscardChangesDialog(context);
          return shouldDiscard;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_name ?? ''),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MachineOperatorDropDownButton(
                    machineOperatorStream: machineOperatorStream,
                    selectedMachineOperator: _machineOperator,
                    onChanged: (p0) {
                      setState(() {
                        _machineOperator = p0;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: args[2] ?? false,
                    validator: (value) => emptyStringInputValidation(value),
                    controller: _recipeNameController,
                    decoration: textFormFieldDecoration(
                      hintText: 'Please enter recipe name',
                      labelText: 'Recipe Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) => numericValueInputValidation(
                      value,
                      NumericDataType.integerType,
                      0,
                      100,
                    ),
                    controller: _recipeCountController,
                    decoration: textFormFieldDecoration(
                      hintText: 'Please enter count value',
                      labelText: 'Count Value',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) => numericValueInputValidation(
                      value,
                      NumericDataType.doubleType,
                      0.0,
                      300.0,
                    ),
                    controller: _recipeTemperatureController,
                    decoration: textFormFieldDecoration(
                      hintText: 'Please enter temperature value',
                      labelText: 'Temperature Value',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) => numericValueInputValidation(
                      value,
                      NumericDataType.doubleType,
                      100.0,
                      3000.0,
                    ),
                    controller: _recipeSpeedController,
                    decoration: textFormFieldDecoration(
                      hintText: 'Please enter speed value',
                      labelText: 'Speed Value',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
