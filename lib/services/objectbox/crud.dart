import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:recipe_management/entities.dart';
import 'package:recipe_management/objectbox.g.dart';

class ObjectBoxStorage {
  static final ObjectBoxStorage _shared = ObjectBoxStorage._sharedInstance();
  ObjectBoxStorage._sharedInstance();
  factory ObjectBoxStorage() => _shared;

  Store store = Store(getObjectBoxModel(), directory: 'objectbox');
  late Stream<List<Recipe>> stream;
  bool hasBeenInitialized = false;

  bool initialize() {
    getApplicationDocumentsDirectory().then(
      (dir) {
        store = Store(
          getObjectBoxModel(),
          directory: join(dir.path, 'objectbox'),
        );
      },
    );
    hasBeenInitialized = true;
    return hasBeenInitialized;
  }

  void close() {
    store.close();
  }

  createRecipe(Recipe recipe, MachineOperator machineOperator) {
    recipe.machineOperator.target = machineOperator;
    store.box<Recipe>().put(recipe);
  }

  Stream<List<Recipe>> readAllRecipe() {
    return stream = store
        .box<Recipe>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
