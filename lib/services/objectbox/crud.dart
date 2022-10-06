import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:recipe_management/entities.dart';
import 'package:recipe_management/objectbox.g.dart';

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: join(dir.path, 'objectbox'));
    return ObjectBox._create(store);
  }

  void close() {
    store.close();
  }

  void createNew(Recipe recipe) {
    store.box<Recipe>().put(recipe);
  }

  Stream<List<Recipe>> readAll() {
    return store
        .box<Recipe>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Recipe? read(int id) {
    return store.box<Recipe>().get(id);
  }

  update(Recipe recipe) {
    store.box<Recipe>().put(recipe);
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

  Stream<List<Recipe>> filterByMachineOperator(String name) {
    QueryBuilder<Recipe> builder = store.box<Recipe>().query();

    builder.link(Recipe_.machineOperator, MachineOperator_.name.equals(name));

    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }
}
