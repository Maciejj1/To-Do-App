import 'package:flutter/material.dart';
import 'package:todo/config/helpers/to_do_button.dart';
import '../../config/helpers/todo-appBar.dart';
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
      appBar: const TodoAppBar(),
      drawer: const TodoDrawer(),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Column(children: [
              const SizedBox(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://media.istockphoto.com/id/1270987867/photo/close-up-young-smiling-man-in-casual-clothes-posing-isolated-on-blue-wall-background-studio.jpg?b=1&s=612x612&w=0&k=20&c=wvRBkbEWoTWO6b_THlthzFPp15bHQxod7kaEB5LfQ5g="),
                  radius: 70,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              ToDoButton(buttonText: "Zmien email", buttonMethod: () {}),
              const SizedBox(
                height: 20,
              ),
              ToDoButton(buttonText: "Zmien hasło", buttonMethod: () {}),
              const SizedBox(
                height: 20,
              ),
              ToDoButton(buttonText: "Usuń konto", buttonMethod: () {}),
              const SizedBox(
                height: 20,
              ),
            ]),
          ],
        ),
      ))),
    );
  }
}
