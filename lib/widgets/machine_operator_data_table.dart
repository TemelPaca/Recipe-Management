import 'package:flutter/material.dart';
import 'package:recipe_management/entities.dart';

class MachineOperatorDataTable extends StatefulWidget {
  final List<MachineOperator> machineOperators;
  final void Function(int columnIndex, bool ascending) onSort;
  final void Function(int id) onDelete;
  final void Function(MachineOperator machineOperator) onEdit;
  final void Function(MachineOperator machineOperator) onSaveAs;

  const MachineOperatorDataTable({
    Key? key,
    required this.machineOperators,
    required this.onSort,
    required this.onDelete,
    required this.onEdit,
    required this.onSaveAs,
  }) : super(key: key);

  @override
  State<MachineOperatorDataTable> createState() =>
      _MachineOperatorDataTableState();
}

class _MachineOperatorDataTableState extends State<MachineOperatorDataTable> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: [
            DataColumn(
              label: const Text('Id'),
              onSort: _onDataColumnSort,
            ),
            const DataColumn(
              label: Text('First Name'),
            ),
            const DataColumn(
              label: Text('Last Name'),
            ),
            DataColumn(
              label: const Text('Email'),
              onSort: _onDataColumnSort,
            ),
            const DataColumn(
              label: Text('Password'),
            ),
            DataColumn(label: Container()),
            DataColumn(label: Container()),
            DataColumn(label: Container()),
          ],
          rows: widget.machineOperators.map((machineOperator) {
            return DataRow(cells: [
              DataCell(
                Text(machineOperator.id.toString()),
              ),
              DataCell(
                Text(machineOperator.firstName),
              ),
              DataCell(
                Text(machineOperator.lastName),
              ),
              DataCell(
                Text(machineOperator.email),
              ),
              DataCell(
                Text(machineOperator.password),
              ),
              DataCell(
                DeleteButton(
                  id: machineOperator.id,
                  onPressed: widget.onDelete,
                ),
              ),
              DataCell(
                EditButton(
                  machineOperator: machineOperator,
                  onPressed: widget.onEdit,
                ),
              ),
              DataCell(
                SaveAsButton(
                  machineOperator: machineOperator,
                  onPressed: widget.onSaveAs,
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void _onDataColumnSort(int columnIndex, ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    widget.onSort(columnIndex, ascending);
  }
}

class DeleteButton extends StatelessWidget {
  final int id;
  final void Function(int id) onPressed;
  const DeleteButton({Key? key, required this.id, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: 'Delete',
        onPressed: () => onPressed(id),
        icon: const Icon(Icons.delete));
  }
}

class EditButton extends StatelessWidget {
  final MachineOperator machineOperator;
  final void Function(MachineOperator machineOperator) onPressed;
  const EditButton(
      {Key? key, required this.machineOperator, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: 'Edit',
        onPressed: () => onPressed(machineOperator),
        icon: const Icon(Icons.edit));
  }
}

class SaveAsButton extends StatelessWidget {
  final MachineOperator machineOperator;
  final void Function(MachineOperator machineOperator) onPressed;
  const SaveAsButton(
      {Key? key, required this.machineOperator, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: 'Save As',
        onPressed: () => onPressed(machineOperator),
        icon: const Icon(Icons.save_as));
  }
}
