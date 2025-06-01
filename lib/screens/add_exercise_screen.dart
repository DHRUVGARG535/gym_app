import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/provider/exercise_provider.dart';
import 'package:uuid/uuid.dart';

class AddExerciseScreen extends ConsumerStatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  ConsumerState<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String selectedDay = 'Friday'; // Default to current day (Friday, May 30, 2025)

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();

  void _saveExercise() {
    if (_formKey.currentState!.validate()) {
      try {
        final newExercise = Exercise(
          id: const Uuid().v4(),
          name: _nameController.text.trim(),
          sets: int.parse(_setsController.text),
          reps: int.parse(_repsController.text),
          day: selectedDay,
        );

        ref.read(exerciseProvider.notifier).addExercise(newExercise);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving exercise: $e')),
        );
      }
    }
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
      appBar: AppBar(title: const Text('Add Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Exercise Name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      controller: _setsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Sets'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final sets = int.tryParse(value);
                        if (sets == null || sets < 0) {
                          return 'Enter a valid non-negative number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      controller: _repsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Reps'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final reps = int.tryParse(value);
                        if (reps == null || reps < 0) {
                          return 'Enter a valid non-negative number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                value: selectedDay,
                items: days
                    .map(
                      (day) => DropdownMenuItem(value: day, child: Text(day)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDay = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Select Day'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveExercise,
                  child: const Text('Save Exercise'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}