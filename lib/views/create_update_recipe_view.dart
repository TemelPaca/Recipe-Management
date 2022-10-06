import 'package:flutter/material.dart';
import 'package:recipe_management/entities.dart';
import 'package:recipe_management/generics/get_arguments.dart';
import 'package:recipe_management/services/objectbox/crud.dart';
import 'package:recipe_management/utilities/dialogs/discard_changes_dialog.dart';
import 'package:recipe_management/utilities/dialogs/save_dialog.dart';
import 'package:recipe_management/widgets/numeric_data_input.dart';

class CreateUpdateRecipeView extends StatefulWidget {
  const CreateUpdateRecipeView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateRecipeView> createState() => _CreateUpdateRecipeViewState();
}

class _CreateUpdateRecipeViewState extends State<CreateUpdateRecipeView> {
  Recipe? _recipe;

  ObjectBox? _objectBox;
  late TextEditingController _machineOperatorController;
  late TextEditingController _recipeNameController;
  late TextEditingController _recipeCountController;
  late TextEditingController _recipeTemperatureController;
  late TextEditingController _recipeSpeedController;
  MachineOperator? machineOperator;
  String? name;
  int? count;
  double? temperature;
  double? speed;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _machineOperatorController = TextEditingController();
    _recipeNameController = TextEditingController();
    _recipeCountController = TextEditingController();
    _recipeTemperatureController = TextEditingController();
    _recipeSpeedController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _machineOperatorController.dispose();
    _recipeNameController.dispose();
    _recipeCountController.dispose();
    _recipeTemperatureController.dispose();
    _recipeSpeedController.dispose();
    super.dispose();
  }

  void _setupTextControllerListener() {
    _machineOperatorController.removeListener(_textControllerListener);
    _machineOperatorController.addListener(_textControllerListener);

    _recipeNameController.removeListener(_textControllerListener);
    _recipeNameController.addListener(_textControllerListener);

    _recipeCountController.removeListener(_textControllerListener);
    _recipeCountController.addListener(_textControllerListener);

    _recipeTemperatureController.removeListener(_textControllerListener);
    _recipeTemperatureController.addListener(_textControllerListener);

    _recipeSpeedController.removeListener(_textControllerListener);
    _recipeSpeedController.addListener(_textControllerListener);
  }

  void _textControllerListener() {
    machineOperator = MachineOperator(
      name: _machineOperatorController.text,
    );
    name = _recipeCountController.text;
    count = int.tryParse(_recipeCountController.text);
    temperature = double.tryParse(_recipeTemperatureController.text);
    speed = double.tryParse(_recipeSpeedController.text);
  }

  void _saveRecipe() {
    _recipe?.machineOperator.target = machineOperator;
    _recipe?.name = _recipeNameController.text;
    _recipe?.count = int.tryParse(_recipeCountController.text)!;
    _recipe?.temperature = double.tryParse(_recipeTemperatureController.text)!;
    _recipe?.speed = double.tryParse(_recipeSpeedController.text)!;
    _objectBox?.createNew(_recipe!);
  }

  void _placeRecipeData() {
    if (_recipe != null) {
      _machineOperatorController.text = _recipe!.machineOperator.target!.name;
      _recipeNameController.text = _recipe!.name;
      _recipeCountController.text = _recipe!.count.toString();
      _recipeTemperatureController.text =
          _recipe!.temperature.toStringAsFixed(2);
      _recipeSpeedController.text = _recipe!.speed.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    var args = context.getArgument<Object>() as List;
    _recipe = args[0] as Recipe?;
    _objectBox = args[1] as ObjectBox?;
    _placeRecipeData();
    _setupTextControllerListener();
    return WillPopScope(
      onWillPop: () async {
        if (_formKey.currentState!.validate()) {
          bool shouldSave = await showSaveDialog(context, _recipe);
          if (shouldSave) {
            _saveRecipe();
          }
          return true;
        } else {
          bool shouldDiscard = await showDiscardChangesDialog(context);
          return shouldDiscard;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recipe ${_recipe?.id ?? ''}'),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Can not be empty !";
                    }
                    return null;
                  },
                  controller: _machineOperatorController,
                  decoration: const InputDecoration(
                    hintText:
                        "Please enter Machine Operator's First Name & Last Name",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Can not be empty !";
                    }
                    return null;
                  },
                  controller: _recipeNameController,
                  decoration: const InputDecoration(
                    hintText: "Please enter a Recipe Name",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    List<dynamic> validatorResult = numericValueInputValidation(
                        value, NumericDataType.integerType, 0, 100);
                    count = validatorResult[1];
                    return validatorResult[0];
                  },
                  controller: _recipeCountController,
                  decoration: const InputDecoration(
                    hintText: "Please enter a Count Value",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    List<dynamic> validatorResult = numericValueInputValidation(
                        value, NumericDataType.doubleType, 0.0, 300.0);
                    temperature = validatorResult[1];
                    return validatorResult[0];
                  },
                  controller: _recipeTemperatureController,
                  decoration: const InputDecoration(
                    hintText: "Please enter a Temperature Value",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    List<dynamic> validatorResult = numericValueInputValidation(
                        value, NumericDataType.doubleType, 100.0, 3000.0);
                    speed = validatorResult[1];
                    return validatorResult[0];
                  },
                  controller: _recipeSpeedController,
                  decoration: const InputDecoration(
                    hintText: "Please enter a Speed Value",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
