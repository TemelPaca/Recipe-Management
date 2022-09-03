import 'package:objectbox/objectbox.dart';

@Entity()
class Recipe {
  int id;
  String name;
  double temperature;
  double speed;
  int count;
  final machineOperator = ToOne<MachineOperator>();

  Recipe({
    this.id = 0,
    required this.name,
    required this.temperature,
    required this.speed,
    required this.count,
  });
}

@Entity()
class MachineOperator {
  int id;
  String name;
  @Backlink()
  final recipes = ToMany<Recipe>();

  MachineOperator({
    this.id = 0,
    required this.name,
  });
}
