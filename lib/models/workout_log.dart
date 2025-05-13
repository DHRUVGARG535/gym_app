class WorkoutLog {
  final String name;
  final int sets;
  final int reps;
  final DateTime date;

  WorkoutLog({
    required this.name,
    required this.sets,
    required this.reps,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'sets': sets,
        'reps': reps,
        'date': date.toIso8601String(),
      };

  factory WorkoutLog.fromJson(Map<String, dynamic> json) {
    return WorkoutLog(
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
      date: DateTime.parse(json['date']),
    );
  }
}