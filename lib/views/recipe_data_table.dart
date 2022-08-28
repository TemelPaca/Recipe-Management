import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:recipe_management/entities.dart';

class RecipeDataTable extends StatefulWidget {
  final List<Recipe> recipes;
  final void Function(int columnIndex, bool ascending) onSort;
  final Store store;

  const RecipeDataTable({
    Key? key,
    required this.recipes,
    required this.onSort,
    required this.store,
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
              DataColumn(label: const Text('ID'), onSort: _onDataColumnSort),
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
              DataColumn(label: Container())
            ],
            rows: widget.recipes.map((recipe) {
              return DataRow(cells: [
                DataCell(
                  Text(recipe.id.toString()),
                ),
                DataCell(
                  Text(recipe.machineOperator.target?.name ?? 'NONE'),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Material(
                          child: ListView(
                            children: recipe.machineOperator.target!.recipes
                                .map(
                                  (_) => ListTile(
                                    title: Text(
                                        '${_.id}    ${_.machineOperator.target?.name}    ${_.name}    ${_.count}'),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    );
                  },
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
                  const Icon(Icons.delete),
                  onTap: () {
                    widget.store.box<Recipe>().remove(recipe.id);
                  },
                ),
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
    widget.onSort(columnIndex, ascending);
  }
}
