import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:todo/config/helpers/to_do_icons_icons.dart';
import 'package:todo/config/helpers/todo-appBar.dart';
import 'package:todo/config/helpers/todo-drawer.dart';
import 'package:todo/pages/dashboard/closed_todos.dart';
import 'package:todo/pages/dashboard/dashboard.dart';

// class ToDoBottomNav extends StatelessWidget {
//   const ToDoBottomNav({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ToDoBottomNavContent();
//   }
// }

class ToDoBottomNavContent extends StatefulWidget {
  const ToDoBottomNavContent(
      {super.key, required this.selectedIndex, required this.onTap});
  final int selectedIndex;
  final Function(int) onTap;
  @override
  State<ToDoBottomNavContent> createState() => _ToDoBottomNavContentState();
}

class _ToDoBottomNavContentState extends State<ToDoBottomNavContent> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF6200EE),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(.60),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: widget.selectedIndex,
      onTap: widget.onTap,
      items: [
        BottomNavigationBarItem(
          label: 'Tasks',
          icon: Icon(ToDoIcons.icon__home_2_),
        ),
        BottomNavigationBarItem(
          label: 'Closed',
          icon: Icon(ToDoIcons.icon__tick_circle_),
        ),
      ],
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static Page<void> page() => const MaterialPage<void>(child: MainPage());
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    ClosedTodos(),
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TodoAppBar(),
      drawer: const TodoDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ToDoBottomNavContent(
        onTap: _onItemTapped,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
