import 'package:flutter/material.dart';
import 'package:gym_app/screens/home_screen.dart';
import 'package:gym_app/screens/profile_screen.dart';
import 'package:gym_app/screens/progress_screen.dart';
import 'package:gym_app/screens/workout_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  Widget activePage = HomeScreen();

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var activeTitle = 'Home';
    Widget activePage = HomeScreen();

    if (_selectedPageIndex == 1) {
      activeTitle = 'Workout Plan';
      activePage = WorkoutScreen();
    }
    if (_selectedPageIndex == 2) {
      activeTitle = 'Progress Screen';
      activePage = ProgressScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(activeTitle),

        actions:
            activeTitle == 'Home'
                ? [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) => ProfileScreen()),
                        );
                      },
                      icon: Icon(Icons.person),
                    ),
                  ),
                ]
                : null,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
        ],
      ),

      body: activePage,
    );
  }
}
