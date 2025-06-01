import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/provider/exercise_provider.dart';
import 'package:gym_app/screens/add_exercise_screen.dart';
import 'package:gym_app/screens/workout_tracker_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? username;
  String? profileImageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (doc.exists) {
      setState(() {
        username = doc.data()?['username'] ?? 'User';
        profileImageUrl = doc.data()?['profileImageUrl'] ?? '';

        isLoading = false;
      });
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    String greeting;
    if (hour >= 5 && hour < 12) {
      greeting = 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return '$greeting, ${username ?? ''}!';
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final today =
        [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        ][DateTime.now().weekday - 1];

    final exerciseList =
        ref.watch(exerciseProvider).where((e) => e.day == today).toList();

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (ctx) => AddExerciseScreen()));
          },
          child: const Icon(Icons.add),
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getGreeting(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            profileImageUrl != null &&
                                    profileImageUrl!.isNotEmpty
                                ? CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(
                                    profileImageUrl!,
                                  ),
                                )
                                : CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey[800],
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Card(
                          color: Colors.teal[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            title: const Text(
                              'Today’s Workout',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: const Text(
                              'Chest & Triceps',
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (ctx) => WorkoutTrackerScreen(
                                          exercises: exerciseList,
                                        ),
                                  ),
                                );
                              },
                              child: const Text('Start'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          color: Colors.blueGrey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const ListTile(
                            title: Text(
                              'Last Workout',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Back Day - Deadlifts, Lat Pulldown\nDuration: 45 mins',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          color: Colors.deepPurple[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            height: 150,
                            width: double.infinity,
                            child: const Center(
                              child: Text(
                                '📈 Progress Chart Coming Soon...',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          color: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flash_on,
                                  size: 32,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '"Push harder than yesterday\nif you want a different tomorrow!"',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium!.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '⚡ Stay consistent, stay strong!',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
