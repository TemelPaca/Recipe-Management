import 'package:flutter/material.dart';
import 'package:recipe_management/entities.dart';
import 'package:recipe_management/generics/get_arguments.dart';
import 'package:recipe_management/services/objectbox/crud.dart';
import 'package:recipe_management/utilities/decorations/text_form_field_decorations.dart';
import 'package:recipe_management/utilities/dialogs/discard_changes_dialog.dart';
import 'package:recipe_management/utilities/dialogs/save_machine_operator_dialog.dart';
import 'package:recipe_management/utilities/text_validation/email_input_validation.dart';
import 'package:recipe_management/utilities/text_validation/empty_string_input_validation.dart';

class CreateUpdateMachineOperatorView extends StatefulWidget {
  const CreateUpdateMachineOperatorView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateMachineOperatorView> createState() =>
      _CreateUpdateMachineOperatorViewState();
}

class _CreateUpdateMachineOperatorViewState
    extends State<CreateUpdateMachineOperatorView> {
  late ObjectBox _objectBox;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  int? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _password;
  MachineOperator? _tempMachineOperator;

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

  void _saveMachineOperator(MachineOperator machineOperator) {
    _objectBox.createNewMachineOperator(machineOperator);
  }

  void _placeRecipeData() {
    _firstNameController.text = _firstName ?? _firstNameController.text;
    _lastNameController.text = _lastName ?? _lastNameController.text;
    _emailController.text = _email ?? _emailController.text;
    _passwordController.text = _password ?? _passwordController.text;
  }

  @override
  Widget build(BuildContext context) {
    var args = context.getArgument<Object>() as List;
    if (args[0] != null) {
      _id = (args[0] as MachineOperator).id;
      _firstName = (args[0] as MachineOperator).firstName;
      _lastName = (args[0] as MachineOperator).lastName;
      _email = (args[0] as MachineOperator).email;
      _password = (args[0] as MachineOperator).password;
      _tempMachineOperator = MachineOperator(
        id: _id!,
        firstName: _firstName!,
        lastName: _lastName!,
        email: _email!,
        password: _password!,
      );
    }
    _objectBox = args[1] as ObjectBox;
    _placeRecipeData();

    return WillPopScope(
      onWillPop: () async {
        if (_formKey.currentState!.validate()) {
          var machineOperator = MachineOperator(
            id: _id ?? 0,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
          if (machineOperator != _tempMachineOperator) {
            bool shouldSave =
                await showSaveMachineOperatorDialog(context, machineOperator);
            if (shouldSave) {
              _saveMachineOperator(machineOperator);
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
          title: Text(_firstName ?? ''),
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
                    validator: (value) => emptyStringInputValidation(value),
                    controller: _firstNameController,
                    decoration: textFormFieldDecoration(
                      hintText: 'Please enter first name',
                      labelText: 'First Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: args[2] ?? false,
                    validator: (value) => emptyStringInputValidation(value),
                    controller: _lastNameController,
                    decoration: textFormFieldDecoration(
                      hintText: 'Please enter last name',
                      labelText: 'Last Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: args[2] ?? false,
                    validator: (value) => emailInputValidation(value),
                    controller: _emailController,
                    decoration: textFormFieldDecoration(
                      hintText: 'Please enter email address',
                      labelText: 'Email Address',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: args[2] ?? false,
                    validator: (value) => emptyStringInputValidation(value),
                    obscureText: true,
                    obscuringCharacter: '?',
                    controller: _passwordController,
                    decoration: textFormFieldDecoration(
                      hintText: 'Please Enter Your Password',
                      labelText: 'Password',
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
