import 'package:flutter/material.dart';
import 'package:recipe_management/entities.dart';
import 'package:recipe_management/generics/get_arguments.dart';
import 'package:recipe_management/services/objectbox/crud.dart';
import 'package:recipe_management/utilities/dialogs/discard_changes_dialog.dart';
import 'package:recipe_management/utilities/dialogs/save_recipe_dialog.dart';
import 'package:recipe_management/utilities/text_validation/numeric_data_input_validation.dart';
import 'package:recipe_management/widgets/machine_operator_dropdown.dart';

class CreateUpdateRecipeView extends StatefulWidget {
  const CreateUpdateRecipeView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateRecipeView> createState() => _CreateUpdateRecipeViewState();
}

class _CreateUpdateRecipeViewState extends State<CreateUpdateRecipeView> {
  Recipe _recipe = Recipe(
    name: '',
    temperature: 0.0,
    speed: 0.0,
    count: 0,
  );
  final Recipe _tempRecipe = Recipe(
    name: '',
    temperature: 0.0,
    speed: 0.0,
    count: 0,
  );

  late ObjectBox _objectBox;

  late TextEditingController _recipeNameController;
  late TextEditingController _recipeCountController;
  late TextEditingController _recipeTemperatureController;
  late TextEditingController _recipeSpeedController;

  bool firstScan = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _recipeNameController = TextEditingController();
    _recipeCountController = TextEditingController();
    _recipeTemperatureController = TextEditingController();
    _recipeSpeedController = TextEditingController();
    firstScan = true;
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

  void _setupTextControllerListener() {
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
    _recipe.name = _recipeNameController.text;
    _recipe.count = int.tryParse(_recipeCountController.text)!;
    _recipe.temperature = double.tryParse(_recipeTemperatureController.text)!;
    _recipe.speed = double.tryParse(_recipeSpeedController.text)!;
  }

  void _saveRecipe() {
    _objectBox.createNewRecipe(_recipe);
  }

  void _placeRecipeData() {
    _recipeNameController.text = _recipe.name;
    _recipeCountController.text = _recipe.count.toString();
    _recipeTemperatureController.text = _recipe.temperature.toStringAsFixed(2);
    _recipeSpeedController.text = _recipe.speed.toStringAsFixed(2);

    _tempRecipe.id = _recipe.id;
    _tempRecipe.machineOperator.target = _recipe.machineOperator.target;
    _tempRecipe.name = _recipe.name;
    _tempRecipe.count = _recipe.count;
    _tempRecipe.temperature = _recipe.temperature;
    _tempRecipe.speed = _recipe.speed;
  }

  @override
  Widget build(BuildContext context) {
    var args = context.getArgument<Object>() as List;
    if (args[0] != null) {
      _recipe = args[0] as Recipe;
    }
    _objectBox = args[1] as ObjectBox;

    if (firstScan == true) {
      _placeRecipeData();
      firstScan = false;
    }

    _setupTextControllerListener();

    var machineOperatorStream = _objectBox.readAllMachineOperator();

    return WillPopScope(
      onWillPop: () async {
        if (_formKey.currentState!.validate()) {
          if ((_tempRecipe != _recipe)) {
            bool shouldSave = await showSaveRecipeDialog(context, _recipe);
            if (shouldSave) {
              _saveRecipe();
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
          title: Text(_recipe.id != 0 ? _recipe.name : ''),
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
                    selectedMachineOperator: _recipe.machineOperator.target,
                    onChanged: (p0) {
                      setState(() {
                        _recipe.machineOperator.target = p0;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: args[2] ?? false,
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
                      String? validatorResult = numericValueInputValidation(
                          value, NumericDataType.integerType, 0, 100);
                      return validatorResult;
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
                      String? validatorResult = numericValueInputValidation(
                          value, NumericDataType.doubleType, 0.0, 300.0);
                      return validatorResult;
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
                      String? validatorResult = numericValueInputValidation(
                          value, NumericDataType.doubleType, 100.0, 3000.0);
                      return validatorResult;
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
      ),
    );
  }
}
