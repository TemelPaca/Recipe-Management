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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipe &&
          runtimeType == other.runtimeType &&
          machineOperator.target == other.machineOperator.target &&
          name == other.name &&
          temperature == other.temperature &&
          speed == other.speed &&
          count == other.count;

  @override
  int get hashCode =>
      machineOperator.target.hashCode +
      name.hashCode +
      temperature.hashCode +
      speed.hashCode +
      count.hashCode;
}

@Entity()
class MachineOperator {
  int id;
  String firstName;
  String lastName;
  String email;
  String password;
  @Backlink()
  final recipes = ToMany<Recipe>();

  MachineOperator({
    this.id = 0,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  String toString() {
    return """
    ***Machine Operator***
    Id : $id
    First Name : $firstName
    Last Name : $lastName
    email : $email
    password : $password
""";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MachineOperator &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          email == other.email &&
          password == other.password;

  @override
  int get hashCode =>
      id.hashCode +
      firstName.hashCode +
      lastName.hashCode +
      email.hashCode +
      password.hashCode;
}
