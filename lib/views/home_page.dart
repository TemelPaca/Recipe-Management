import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipe_management/constants/routes.dart';
import 'package:recipe_management/entities.dart';
import 'package:recipe_management/objectbox.g.dart';
import 'package:path/path.dart';
import 'package:recipe_management/services/objectbox/crud.dart';
import 'package:recipe_management/views/recipe_data_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Store _store;
  bool hasBeenInitialized = false;
  late MachineOperator _machineOperator;
  late Stream<List<Recipe>> _stream;
  // final ObjectBoxStorage storage = ObjectBoxStorage();

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   hasBeenInitialized = storage.initialize();
    //   _stream = storage.readAllRecipe();
    // });

    getApplicationDocumentsDirectory().then(
      (dir) {
        _store = Store(
          getObjectBoxModel(),
          directory: join(dir.path, 'objectbox'),
        );
        setState(() {
          _stream = _store
              .box<Recipe>()
              .query()
              .watch(triggerImmediately: true)
              .map((query) => query.find());
          hasBeenInitialized = true;
        });
      },
    );
  }

  @override
  void dispose() {
    _store.close();
    // storage.close();
    super.dispose();
  }

  void setMachineOperator() {
    _machineOperator = MachineOperator(name: 'Burcu Paça');
  }

  void addRecipe() {
    final recipe = Recipe(
      name: 'Recipe#3',
      temperature: 111.11,
      speed: 2222.22,
      count: 3333,
    );
    recipe.machineOperator.target = _machineOperator;
    _store.box<Recipe>().put(recipe);
    // storage.createRecipe(recipe, _machineOperator);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            onPressed: setMachineOperator,
            icon: const Icon(Icons.person_add_alt),
          ),
          IconButton(
            onPressed: () {
              // Navigator.of(context).pushNamed(createOrUpdateRecipeRoute);
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
                    final newQueryBuilder = _store.box<Recipe>().query();
                    final sortField =
                        columnIndex == 0 ? Recipe_.id : Recipe_.count;

                    newQueryBuilder.order(sortField,
                        flags: ascending ? 0 : Order.descending);

                    setState(() {
                      _stream = newQueryBuilder
                          .watch(triggerImmediately: true)
                          .map((query) => query.find());
                    });
                  },
                  store: _store,
                  // store: storage.store,
                );
              },
            ),
    );
  }
}
