import 'package:gym_app/models/exercise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class ExerciseNotifier extends StateNotifier<List<Exercise>> {
  ExerciseNotifier() : super([]);

  Future<Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'exercise.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE exercises(id TEXT PRIMARY KEY,name TEXT,sets INTEGER,reps INTEGER, day TEXT)',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<void> loadExercises() async {
    final db = await getDatabase();
    final data = await db.query('exercises');
    final exercises =
        data
            .map(
              (row) => Exercise(
                id: row['id'] as String,
                name: row['name'] as String,
                sets: row['sets'] as int,
                reps: row['reps'] as int,
                day: row['day'] as String,
              ),
            )
            .toList();

    state = exercises;
  }

  void addExercise(Exercise exercise) async {
    final db = await getDatabase();

    db.insert('exercises', {
      'id': exercise.id,
      'name': exercise.name,
      'reps': exercise.reps,
      'sets': exercise.sets,
      'day': exercise.day,
    });

    state = [...state, exercise];
  }
}

final exerciseProvider =
    StateNotifierProvider<ExerciseNotifier, List<Exercise>>(
      (ref) => ExerciseNotifier(),
    );
