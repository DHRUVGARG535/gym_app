import 'package:flutter/material.dart';
import 'package:gym_app/models/exercise.dart';

class WorkoutTrackerScreen extends StatefulWidget {
  final List<Exercise> exercises;

  const WorkoutTrackerScreen({super.key, required this.exercises});

  @override
  State<WorkoutTrackerScreen> createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  final Map<int, List<Map<String, dynamic>>> _loggedData = {};

  void _logSet(int index, double weight, int reps) {
    setState(() {
      _loggedData.putIfAbsent(index, () => []).add({
        'weight': weight,
        'reps': reps,
      });
    });
  }

  

  

  void _showLogDialog(int index) {
    final weightController = TextEditingController();
    final repsController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              'Log Set for ${widget.exercises[index].name}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
                TextField(
                  controller: repsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Reps'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final weight = double.tryParse(weightController.text);
                  final reps = int.tryParse(repsController.text);
                  if (weight != null && reps != null) {
                    _logSet(index, weight, reps);
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text('Log Set'),
              ),
            ],
          ),
    );
  }

  void _finishWorkout() {
    // You can save this _loggedData to Firebase/local DB later
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              'Workout Completed!',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: Text(
              'Great job, Dhruv! Your progress has been logged.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onTertiaryContainer;

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Tracker')),
      body: ListView.builder(
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) {
          final exercise = widget.exercises[index];
          final logs = _loggedData[index] ?? [];

          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.copyWith(color: color),
                  ),
                  const SizedBox(height: 6),
                  ...logs.map(
                    (log) => Text(
                      'Set: ${log['weight']} kg x ${log['reps']} reps',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(color: color),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () => _showLogDialog(index),
                    child: const Text('Log Set'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _finishWorkout,
        label: Text('Finish Workout'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
