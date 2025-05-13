import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/workout_screen.dart';
import 'screens/progress_screen.dart';

void main() {
  runApp(const GymApp());
}

class GymApp extends StatefulWidget {
  const GymApp({super.key});

  @override
  State<GymApp> createState() => _GymAppState();
}

class _GymAppState extends State<GymApp> {
  String currentScreen = 'home';

  void switchScreen(String screenName) {
    setState(() {
      currentScreen = screenName;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = HomeScreen(onSelectScreen: switchScreen);

    if (currentScreen == 'workout') {
      screenWidget = WorkoutScreen(onBack: switchScreen);
    } else if (currentScreen == 'progress') {
      screenWidget = ProgressScreen(onBack: switchScreen);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: screenWidget,
      ),
    );
  }
}
