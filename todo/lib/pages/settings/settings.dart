import 'package:flutter/material.dart';
import 'package:todo/pages/dashboard/todo-list/view/todo.dart';

import '../../config/helpers/todo-appBar.dart';
import '../../config/helpers/todo-bottomNavBar.dart';
import '../../config/helpers/todo-drawer.dart';

class ToDoSettings extends StatefulWidget {
  const ToDoSettings({super.key});
  static Page<void> page() => const MaterialPage<void>(child: ToDoSettings());
  @override
  State<ToDoSettings> createState() => _ToDoSettingsState();
}

class _ToDoSettingsState extends State<ToDoSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TodoAppBar(),
      drawer: TodoDrawer(),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Zmien email'),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Zmien hasło'),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Usuń konto'),
        ),
        SizedBox(
          height: 20,
        ),
      ]))),
    );
  }
}
