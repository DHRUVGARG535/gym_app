import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Exercise {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final String day;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.day,
    String? id,
  }) : id = id ?? uuid.v4();

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'sets': sets, 'reps': reps, 'day': day};
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      day: map['day'],
    );
  }
}
