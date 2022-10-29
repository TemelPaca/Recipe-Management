import 'package:flutter/material.dart';
import 'package:recipe_management/constants/routes.dart';
import 'package:recipe_management/entities.dart';
import 'package:recipe_management/generics/get_arguments.dart';
import 'package:recipe_management/services/objectbox/crud.dart';
import 'package:recipe_management/widgets/machine_operator_data_table.dart';

import '../utilities/dialogs/machine_operator_delete_dialog.dart';

class MachineOperatorsListView extends StatefulWidget {
  const MachineOperatorsListView({Key? key}) : super(key: key);

  @override
  State<MachineOperatorsListView> createState() =>
      _MachineOperatorsListViewState();
}

class _MachineOperatorsListViewState extends State<MachineOperatorsListView> {
  late Stream<List<MachineOperator>> _machineOperatorStream;
  late ObjectBox _objectBox;
  bool firstScan = false;

  @override
  void initState() {
    firstScan = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args = context.getArgument<Object>() as List;
    if (args[1] != null) {
      _objectBox = args[1] as ObjectBox;
    }
    if (firstScan == true) {
      _machineOperatorStream = _objectBox.readAllMachineOperator();
      firstScan = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Machine Operators'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.receipt),
            tooltip: 'Recipes',
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                  createOrUpdateMachineOperatorRoute,
                  arguments: [null, _objectBox, null]);
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add New Machine Operator',
          )
        ],
      ),
      body: StreamBuilder<List<MachineOperator>>(
        stream: _machineOperatorStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return MachineOperatorDataTable(
            machineOperators: snapshot.data!,
            onSort: (columnIndex, ascending) {
              setState(() {
                _machineOperatorStream =
                    _objectBox.sortAllMachineOperators(columnIndex, ascending);
              });
            },
            onDelete: (id) async {
              final machineOperator = _objectBox.readMachineOperator(id);
              final shouldDelete = await showMachineOperatorDeleteDialog(
                  context, machineOperator);
              if (shouldDelete) _objectBox.deleteMachineOperator(id);
            },
            onEdit: (machineOperator) {
              Navigator.of(context).pushNamed(
                  createOrUpdateMachineOperatorRoute,
                  arguments: [machineOperator, _objectBox, null]);
            },
            onSaveAs: (machineOperator) {
              machineOperator.id = 0;
              Navigator.of(context).pushNamed(
                  createOrUpdateMachineOperatorRoute,
                  arguments: [machineOperator, _objectBox, true]);
            },
          );
        },
      ),
    );
  }
}
