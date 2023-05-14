import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:todo/config/bloc/app_bloc.dart';
import 'package:todo/config/helpers/todo-appBar.dart';
import 'package:todo/config/helpers/todo-bottomNavBar.dart';
import 'package:todo/config/helpers/todo-drawer.dart';

class Dashboard extends StatefulWidget {
  static Page<void> page() => const MaterialPage<void>(child: Dashboard());
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isChecked = false;
  var heart = Emoji('heart', '❤️');
  static const IconData trash = IconData(0xf4c4);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      appBar: const TodoAppBar(),
      drawer: TodoDrawer(),
      bottomNavigationBar: const ToDoBottomNav(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text('Witaj w To-Do')],
            ),
            Column(
              children: [
                SizedBox(
                  // height: 300,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              color: Colors.blueAccent,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          fillColor: MaterialStateProperty.all(
                                              const Color(0xFF6200EE)),
                                          value: isChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isChecked = value!;
                                            });
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text("❤️"),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: const Text(
                                                        'Nazwa taska'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: const Text("Today"),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.delete))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
