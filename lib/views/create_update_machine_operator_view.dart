import 'package:flutter/material.dart';
import 'package:recipe_management/entities.dart';
import 'package:recipe_management/generics/get_arguments.dart';
import 'package:recipe_management/services/objectbox/crud.dart';
import 'package:recipe_management/utilities/dialogs/discard_changes_dialog.dart';
import 'package:recipe_management/utilities/dialogs/save_machine_operator_dialog.dart';

class CreateUpdateMachineOperatorView extends StatefulWidget {
  const CreateUpdateMachineOperatorView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateMachineOperatorView> createState() =>
      _CreateUpdateMachineOperatorViewState();
}

class _CreateUpdateMachineOperatorViewState
    extends State<CreateUpdateMachineOperatorView> {
  MachineOperator _machineOperator = MachineOperator(
    firstName: '',
    lastName: '',
    email: '',
    password: '',
  );
  final MachineOperator _tempMachineOperator = MachineOperator(
    firstName: '',
    lastName: '',
    email: '',
    password: '',
  );
  late ObjectBox _objectBox;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setupTextControllerListener() {
    _firstNameController.removeListener(_textControllerListener);
    _firstNameController.addListener(_textControllerListener);

    _lastNameController.removeListener(_textControllerListener);
    _lastNameController.addListener(_textControllerListener);

    _emailController.removeListener(_textControllerListener);
    _emailController.addListener(_textControllerListener);

    _passwordController.removeListener(_textControllerListener);
    _passwordController.addListener(_textControllerListener);
  }

  void _textControllerListener() {
    _machineOperator.firstName = _firstNameController.text;
    _machineOperator.lastName = _lastNameController.text;
    _machineOperator.email = _emailController.text;
    _machineOperator.password = _passwordController.text;
  }

  void _saveMachineOperator() {
    _objectBox.createNewMachineOperator(_machineOperator);
  }

  void _placeRecipeData() {
    _firstNameController.text = _machineOperator.firstName;
    _lastNameController.text = _machineOperator.lastName;
    _emailController.text = _machineOperator.email;
    _passwordController.text = _machineOperator.password;

    _tempMachineOperator.id = _machineOperator.id;
    _tempMachineOperator.firstName = _machineOperator.firstName;
    _tempMachineOperator.lastName = _machineOperator.lastName;
    _tempMachineOperator.email = _machineOperator.email;
    _tempMachineOperator.password = _machineOperator.password;
  }

  @override
  Widget build(BuildContext context) {
    var args = context.getArgument<Object>() as List;
    if (args[0] != null) {
      _machineOperator = args[0] as MachineOperator;
    }
    _objectBox = args[1] as ObjectBox;
    _placeRecipeData();
    _setupTextControllerListener();

    return WillPopScope(
      onWillPop: () async {
        if (_formKey.currentState!.validate()) {
          if (_tempMachineOperator != _machineOperator) {
            bool shouldSave =
                await showSaveMachineOperatorDialog(context, _machineOperator);
            if (shouldSave) {
              _saveMachineOperator();
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
          title: Text(_machineOperator.id != 0
              ? '${_machineOperator.firstName} ${_machineOperator.lastName}'
              : ''),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      hintText: "Please enter a First Name",
                    ),
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
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      hintText: "Please enter a Last Name",
                    ),
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
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "Please enter a email",
                    ),
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
                    obscureText: true,
                    obscuringCharacter: '?',
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: "Please enter a password",
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
