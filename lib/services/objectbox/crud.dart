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

  void createNewRecipe(Recipe recipe) {
    store.box<Recipe>().put(recipe);
  }

  Stream<List<Recipe>> readAllRecipe() {
    return store
        .box<Recipe>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Recipe? readRecipe(int id) {
    return store.box<Recipe>().get(id);
  }

  update(Recipe recipe) {
    store.box<Recipe>().put(recipe, mode: PutMode.update);
  }

  void deleteRecipe(int id) {
    store.box<Recipe>().remove(id);
  }

  Stream<List<Recipe>> sortAllRecipes(int columnIndex, bool ascending) {
    final newQueryBuilder = store.box<Recipe>().query();
    final sortField = columnIndex == 0 ? Recipe_.id : Recipe_.count;
    newQueryBuilder.order(sortField, flags: ascending ? 0 : Order.descending);
    return newQueryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Stream<List<Recipe>> filterByMachineOperator(int id) {
    QueryBuilder<Recipe> builder = store.box<Recipe>().query();

    builder.link(Recipe_.machineOperator, MachineOperator_.id.equals(id));

    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  void createNewMachineOperator(MachineOperator machineOperator) {
    store.box<MachineOperator>().put(machineOperator);
  }

  MachineOperator? readMachineOperator(int id) {
    return store.box<MachineOperator>().get(id);
  }

  Stream<List<MachineOperator>> readAllMachineOperator() {
    return store
        .box<MachineOperator>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  void deleteMachineOperator(int id) {
    store.box<MachineOperator>().remove(id);
  }

  Stream<List<MachineOperator>> sortAllMachineOperators(
      int columnIndex, bool ascending) {
    final newQueryBuilder = store.box<MachineOperator>().query();
    final sortField =
        columnIndex == 0 ? MachineOperator_.id : MachineOperator_.id;
    newQueryBuilder.order(sortField, flags: ascending ? 0 : Order.descending);
    return newQueryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
