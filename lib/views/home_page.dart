import 'package:flutter/material.dart';
import 'package:recipe_management/constants/routes.dart';
import 'package:recipe_management/entities.dart';
import 'package:recipe_management/services/objectbox/crud.dart';
import 'package:recipe_management/views/recipe_data_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasBeenInitialized = false;
  late Stream<List<Recipe>> _stream;
  late final ObjectBox objectBox;

  @override
  void initState() {
    super.initState();
    ObjectBox.create().then(
      (value) {
        objectBox = value;

        setState(() {
          // _stream = objectBox.readAll();
          _stream = objectBox.filter();
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

  void addRecipe() {
    final recipe = Recipe(
      name: 'Recipe#3',
      temperature: 111.11,
      speed: 2222.22,
      count: 1,
    );

    final machineOperator = MachineOperator(name: 'Ece Paça');
    objectBox.createNew(recipe, machineOperator);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_add_alt),
          ),
          IconButton(
            onPressed: () {
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     createOrUpdateRecipeRoute, (route) => false);
              addRecipe();
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: !hasBeenInitialized
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<List<Recipe>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return RecipeDataTable(
                  recipes: snapshot.data!,
                  onSort: (columnIndex, ascending) {
                    // final newQueryBuilder = _store.box<Recipe>().query();
                    // final sortField =
                    //     columnIndex == 0 ? Recipe_.id : Recipe_.count;

                    // newQueryBuilder.order(sortField,
                    //     flags: ascending ? 0 : Order.descending);

                    // setState(() {
                    //   _stream = newQueryBuilder
                    //       .watch(triggerImmediately: true)
                    //       .map((query) => query.find());
                    // });

                    setState(() {
                      _stream = objectBox.sortAll(columnIndex, ascending);
                    });
                  },
                  onDelete: (id) {
                    objectBox.delete(id);
                  },
                );
              },
            ),
    );
  }
}
