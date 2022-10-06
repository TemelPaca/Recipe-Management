import 'package:flutter/material.dart';
import 'package:recipe_management/entities.dart';

class RecipeDataTable extends StatefulWidget {
  final List<Recipe> recipes;
  final void Function(int columnIndex, bool ascending) onSort;
  final void Function(int id) onDelete;
  final void Function(Recipe recipe) onEdit;

  const RecipeDataTable({
    Key? key,
    required this.recipes,
    required this.onSort,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<RecipeDataTable> createState() => _RecipeDataTableState();
}

class _RecipeDataTableState extends State<RecipeDataTable> {
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
                label: const Text('ID'),
                onSort: _onDataColumnSort,
              ),
              const DataColumn(
                label: Text('Machine Operator'),
              ),
              const DataColumn(
                label: Text('Recipe Name'),
              ),
              DataColumn(
                label: const Text('Count'),
                numeric: true,
                onSort: _onDataColumnSort,
              ),
              const DataColumn(
                label: Text('Temperature'),
                numeric: true,
              ),
              const DataColumn(
                label: Text('Speed'),
                numeric: true,
              ),
              DataColumn(label: Container()),
              DataColumn(label: Container())
            ],
            rows: widget().recipes.map((recipe) {
              return DataRow(cells: [
                DataCell(
                  Text(recipe.id.toString()),
                  // onTap: () => widget().onTap(recipe),
                ),
                DataCell(
                  Text(recipe.machineOperator.target?.name ?? 'NONE'),
                ),
                DataCell(
                  Text(recipe.name),
                ),
                DataCell(
                  Text('${recipe.count}'),
                ),
                DataCell(
                  Text('${recipe.temperature}'),
                ),
                DataCell(
                  Text('${recipe.speed}'),
                ),
                DataCell(
                  DeleteButton(
                    id: recipe.id,
                    onPressed: widget().onDelete,
                  ),
                ),
                DataCell(EditButton(
                  recipe: recipe,
                  onPressed: widget().onEdit,
                )),
              ]);
            }).toList(),
          ),
        ));
  }

  void _onDataColumnSort(int columnIndex, ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    widget().onSort(columnIndex, ascending);
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
        onPressed: () => onPressed(id), icon: const Icon(Icons.delete));
  }
}

class EditButton extends StatelessWidget {
  final Recipe recipe;
  final void Function(Recipe recipe) onPressed;
  const EditButton({Key? key, required this.recipe, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => onPressed(recipe), icon: const Icon(Icons.edit));
  }
}
