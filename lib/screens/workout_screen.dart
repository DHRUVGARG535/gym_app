import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_app/widgets/exercise_title.dart';
import 'package:gym_app/models/workout_log.dart';

class WorkoutScreen extends StatefulWidget {
  final void Function(String) onBack;

  const WorkoutScreen({super.key, required this.onBack});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  List<WorkoutLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedData = prefs.getStringList('workout_logs');

    if (savedData != null) {
      setState(() {
        _logs =
            savedData.map((e) => WorkoutLog.fromJson(jsonDecode(e))).toList();
      });
    }
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = _logs.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('workout_logs', encodedList);
  }

  void _addWorkout() {
    final name = _nameController.text;
    final sets = int.tryParse(_setsController.text);
    final reps = int.tryParse(_repsController.text);

    if (name.isEmpty || sets == null || reps == null) return;

    setState(() {
      _logs.add(
        WorkoutLog(name: name, sets: sets, reps: reps, date: DateTime.now()),
      );
      _nameController.clear();
      _setsController.clear();
      _repsController.clear();
    });
    _saveLogs();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout Logger',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.onBack('home'),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Exercise Name'),
            ),
            TextField(
              controller: _setsController,
              decoration: const InputDecoration(labelText: 'Sets'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _repsController,
              decoration: const InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Workout',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Logged Workouts:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child:
                  _logs.isEmpty
                      ? const Center(child: Text('No workouts logged yet.'))
                      : ListView.builder(
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          return ExerciseTitle(workoutLog: _logs[index]);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
