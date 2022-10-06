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

  @override
  String toString() {
    return """
    ***Recipe***
    Id : $id
    Machine Operator : ${machineOperator.target}
    Name : $name
    Temperature : $temperature
    Speed : $speed
    Count : $count
""";
  }

  @override
  bool operator ==(Object other) {
    return other is Recipe &&
        other.id == id &&
        other.machineOperator == machineOperator &&
        other.name == name &&
        other.temperature == temperature &&
        other.speed == speed &&
        other.count == count;
  }

  @override
  int get hashCode => this.hashCode;
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

  @override
  String toString() {
    return name;
  }
}
