import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: currentPageIndex,
      destinations: <Widget>[
        NavigationDestination(
          icon: const Icon(Icons.home),
          selectedIcon: const Icon(Icons.home_filled),
          label: 'Home',
        ),
        NavigationDestination(
          icon: const Icon(Icons.flatware),
          selectedIcon: const Icon(Icons.flatware_outlined),
          label: 'Pantry',
        ),
        NavigationDestination(
          icon: Icon(Icons.play_circle),
          selectedIcon: Icon(Icons.play_circle_fill),
          label: 'View Posts',
        ),
        NavigationDestination(
          icon: const Icon(Icons.add_a_photo),
          selectedIcon: Icon(Icons.add_a_photo_outlined),
          label: 'Post',
        ),
        NavigationDestination(
          icon: const Icon(Icons.edit),
          selectedIcon: const Icon(Icons.edit),
          label: 'Write a Recipe',
        ),
      ],
    );
  }
}
