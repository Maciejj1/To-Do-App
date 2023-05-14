import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ToDoBottomNav extends StatelessWidget {
  const ToDoBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF6200EE),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(.60),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      onTap: (value) {
        // Respond to item press.
      },
      items: [
        BottomNavigationBarItem(
          label: 'Tasks',
          icon: Icon(Icons.favorite),
        ),
        BottomNavigationBarItem(
          label: 'Closed',
          icon: Icon(Icons.music_note),
        ),
        // BottomNavigationBarItem(
        //   label: 'Places',
        //   icon: Icon(Icons.location_on),
        // ),
      ],
    );
  }
}
