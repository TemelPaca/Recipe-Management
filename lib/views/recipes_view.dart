import 'package:flutter/material.dart';
import 'package:recipe_management/constants/routes.dart';
import 'package:recipe_management/entities.dart';
import 'package:recipe_management/services/objectbox/crud.dart';
import 'package:recipe_management/utilities/dialogs/recipe_delete_dialog.dart';
import 'package:recipe_management/widgets/recipe_data_table.dart';

class RecipeListView extends StatefulWidget {
  const RecipeListView({Key? key}) : super(key: key);

  @override
  State<RecipeListView> createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  bool hasBeenInitialized = false;
  late Stream<List<Recipe>> _recipeStream;
  late final ObjectBox objectBox;

  @override
  void initState() {
    super.initState();
    ObjectBox.create().then(
      (value) {
        objectBox = value;

        setState(() {
          _recipeStream = objectBox.readAllRecipe();
          hasBeenInitialized = true;
        });
      },
    );
  }

  @override
  void dispose() {
    objectBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(machineOperatorsRoute,
                  arguments: [null, objectBox, null]);
            },
            icon: const Icon(Icons.person),
            tooltip: 'Machine Operators',
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateRecipeRoute,
                  arguments: [null, objectBox, null]);
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add New Recipe',
          )
        ],
      ),
      body: !hasBeenInitialized
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<List<Recipe>>(
              stream: _recipeStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return RecipeDataTable(
                  recipes: snapshot.data!,
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _recipeStream =
                          objectBox.sortAllRecipes(columnIndex, ascending);
                    });
                  },
                  onDelete: (id) async {
                    final recipe = objectBox.readRecipe(id);
                    final shouldDelete =
                        await showRecipeDeleteDialog(context, recipe);
                    if (shouldDelete) objectBox.deleteRecipe(id);
                  },
                  onEdit: (recipe) {
                    Navigator.of(context).pushNamed(createOrUpdateRecipeRoute,
                        arguments: [recipe, objectBox, null]);
                  },
                  onSaveAs: (recipe) {
                    recipe.id = 0;
                    recipe.name = '';
                    Navigator.of(context).pushNamed(createOrUpdateRecipeRoute,
                        arguments: [recipe, objectBox, true]);
                  },
                );
              },
            ),
    );
  }
}
