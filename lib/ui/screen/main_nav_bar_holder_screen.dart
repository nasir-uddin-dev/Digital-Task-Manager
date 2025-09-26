import 'package:flutter/material.dart';
import 'package:task_management_app/ui/screen/cancel_task_screen.dart';
import 'package:task_management_app/ui/screen/complete_task_screen.dart';
import 'package:task_management_app/ui/screen/new_task_screen.dart';
import 'package:task_management_app/ui/screen/progress_task_screen.dart';

import '../widgets/tm_app_bar.dart';

class MainNavBarHolderScreen extends StatefulWidget {
  const MainNavBarHolderScreen({super.key});

  static const String name = '/dashboard';

  @override
  State<MainNavBarHolderScreen> createState() => _MainNavBarHolderScreenState();
}

class _MainNavBarHolderScreenState extends State<MainNavBarHolderScreen> {
  int _selectedIndex = 0; //private variable_name
  final List<Widget> _screens = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CancelTaskScreen(),
    CompleteTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: THAppBar(),
        body: _screens[_selectedIndex],
        bottomNavigationBar: NavigationBar(
            //Creates a Material 3 Navigation Bar component.
            backgroundColor: Colors.white,
            selectedIndex: _selectedIndex, //assign _selectedIndex
            onDestinationSelected: (int index) {
              //void Function(function parameter integer)
              setState(() {
                //rebuild UI
                _selectedIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.new_label,
                ),
                label: "New Task",
              ),
              NavigationDestination(
                  icon: Icon(Icons.refresh), label: "Progress"),
              NavigationDestination(
                  icon: Icon(Icons.cancel), label: "Cancelled"),
              NavigationDestination(icon: Icon(Icons.done), label: "Completed"),
            ]));
  }
}


