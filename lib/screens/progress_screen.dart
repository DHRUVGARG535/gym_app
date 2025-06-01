import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressEntry {
  final double weight;
  final DateTime date;

  ProgressEntry({required this.weight, required this.date});

  Map<String, dynamic> toJson() => {
    'weight': weight,
    'date': date.toIso8601String(),
  };

  factory ProgressEntry.fromJson(Map<String, dynamic> json) {
    return ProgressEntry(
      weight: json['weight'],
      date: DateTime.parse(json['date']),
    );
  }
}

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<ProgressEntry> _entries = [];

  void _removeEntry(ProgressEntry entry) {
    setState(() {
      _entries.remove(entry);
    });
    _saveEntries();
  }

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedData = prefs.getStringList('progress_entries');

    if (savedData != null) {
      setState(() {
        _entries =
            savedData
                .map((e) => ProgressEntry.fromJson(jsonDecode(e)))
                .toList();
      });
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = _entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('progress_entries', encodedList);
  }

  void _addEntry() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              'Add Progress',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter Weight (kg)'),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final enteredWeight = double.tryParse(controller.text);
                  if (enteredWeight != null) {
                    setState(() {
                      _entries.add(
                        ProgressEntry(
                          weight: enteredWeight,
                          date: DateTime.now(),
                        ),
                      );
                    });
                    _saveEntries();
                  }
                  Navigator.of(ctx).pop();
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _entries.isEmpty
              ? const Center(
                child: Text(
                  "No progress entries yet.",
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (ctx, index) {
                  final entry = _entries[index];
                  return ListTile(
                    trailing: IconButton(
                      onPressed: () {
                        _removeEntry(entry);
                      },
                      icon: Icon(Icons.delete),
                    ),
                    leading: const Icon(Icons.fitness_center),
                    title: Text("${entry.weight} kg"),
                    subtitle: Text(_formatDate(entry.date)),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        child: const Icon(Icons.add),
      ),
    );
  }
}
