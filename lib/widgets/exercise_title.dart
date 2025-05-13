import 'package:flutter/material.dart';
import 'package:gym_app/models/workout_log.dart';

class ExerciseTitle extends StatelessWidget {
  final WorkoutLog workoutLog;

  const ExerciseTitle({super.key, required this.workoutLog});

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.fitness_center, color: Colors.blue),
      title: Text(
        workoutLog.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${workoutLog.sets} sets x ${workoutLog.reps} reps'),
      trailing: Text(
        _formatDate(workoutLog.date),
        style: const TextStyle(fontSize: 12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}