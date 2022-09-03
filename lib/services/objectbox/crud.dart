import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:recipe_management/entities.dart';
import 'package:recipe_management/objectbox.g.dart';

class ObjectBox {
  late final Store store;

  // static final ObjectBox _singleton = ObjectBox._internal();
  // factory ObjectBox() => _singleton;
  // ObjectBox._internal();

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: join(dir.path, 'objectbox'));
    return ObjectBox._create(store);
  }

  void close() {
    store.close();
  }

  void createNew(Recipe recipe, MachineOperator machineOperator) {
    recipe.machineOperator.target = machineOperator;
    store.box<Recipe>().put(recipe);
  }

  Stream<List<Recipe>> readAll() {
    return store
        .box<Recipe>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  void delete(int id) {
    store.box<Recipe>().remove(id);
  }

  Stream<List<Recipe>> sortAll(int columnIndex, bool ascending) {
    final newQueryBuilder = store.box<Recipe>().query();
    final sortField = columnIndex == 0 ? Recipe_.id : Recipe_.count;
    newQueryBuilder.order(sortField, flags: ascending ? 0 : Order.descending);
    return newQueryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Stream<List<Recipe>> filter() {
    QueryBuilder<Recipe> builder =
        store.box<Recipe>().query(Recipe_.count.equals(3333));

    builder.link(
        Recipe_.machineOperator, MachineOperator_.name.equals('Ece Paça'));

    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }
}
