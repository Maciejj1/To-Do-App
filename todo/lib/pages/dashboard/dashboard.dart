// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:todo/config/helpers/to_do_icons_icons.dart';
import 'package:todo/pages/dashboard/todo-list/cubit/to_do_list_cubit.dart';
import 'package:todo/pages/dashboard/todo-list/service/to_do_list_model.dart';
import 'package:todo/pages/dashboard/widgets/todo_card.dart';

class Dashboard extends StatefulWidget {
  static Page<void> page() => const MaterialPage<void>(child: Dashboard());
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool refreshList = false;
  bool isChecked = false;
  var heart = Emoji('heart', '❤️');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6200EE),
        child: const Icon(ToDoIcons.icon__add_),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return BlocProvider(
                  create: (context) => ToDoCubit(),
                  child: ToDoForm(),
                );
              });
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: SizedBox(
                height: MediaQuery.of(context).size.height - 90,
                width: MediaQuery.of(context).size.width,
                child: Center(child: bodyOfTodo()))),
      ),
    );
  }

  Widget blocBody() {
    return BlocProvider(
      create: (context) => ToDoCubit()..getAllTodo(),
      child: BlocConsumer<ToDoCubit, ToDoState>(
        listener: (context, state) {
          if (state is ToDoSucces) {
            setState(() {
              refreshList =
                  true; // Ustawienie wartości na true, aby odświeżyć listę
            });
          }
        },
        builder: (context, state) {
          if (state is ToDoLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is ToDoError) {
            return const Center(
              child: Text('Coś poszło nie tak'),
            );
          }

          if (state is ToDoSucces) {
            var todoList =
                state.todos!.where((element) => element.status == 0).toList();
            return ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                });
              },
              children: [
                for (int index = 0; index < todoList.length; index += 1)
                  ToDoCard(
                    key: ValueKey(todoList[index].id), // Assign a unique key
                    todo: todoList[index], todoNumber: '',
                  ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget bodyOfTodo() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                flex: 9,
                child: BlocBuilder<ToDoCubit, ToDoState>(
                  builder: (context, state) {
                    if (state is ToDoLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ToDoInitial) {
                      return const Center(child: Text('Pusto'));
                    } else if (state is ToDoSucces) {
                      var todoList = state.todos!
                          .where((element) => element.status == 0)
                          .toList();
                      if (todoList.isEmpty) {
                        return const Center(
                            child: Text('Dodaj pierwsze zadanie'));
                      }
                      return Center(
                          child: ReorderableListView(
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                          });
                        },
                        children: [
                          for (int index = 1;
                              index < todoList.length;
                              index += 1)
                            ToDoCard(
                              todoNumber: '$index',
                              key: ValueKey(
                                  todoList[index].id), // Assign a unique key
                              todo: todoList[index],
                            ),
                        ],
                      ));
                    } else {
                      return Center(
                          child:
                              Text((state as ToDoError).error ?? '_errorText'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ToDoForm() {
    final TextEditingController controller = TextEditingController();
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                  context.read<ToDoCubit>().getAllTodo();
                },
                icon: const Icon(Icons.close)),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Text('Dodaj nowe zadanie'),
        const SizedBox(
          height: 20,
        ),
        ToDoAddTextfield(
          controller: controller,
        ),
        const SizedBox(
          height: 20,
        ),
        ToDoAddButton(
          refreshAction: () {
            context.read<ToDoCubit>().addTodo(Todo(
                todoText: controller.text.trim(),
                createdAt: Timestamp.now(),
                status: 0));
            setState(() {});
            context.read<ToDoCubit>().getAllTodo();
          },
          controller: controller,
        )
      ],
    );
  }

  Widget ToDoAddButton(
      {required TextEditingController controller,
      required Function refreshAction}) {
    return BlocBuilder<ToDoCubit, ToDoState>(
      builder: (context, state) {
        return state is ToDoLoading
            ? const CircularProgressIndicator.adaptive()
            : ElevatedButton(
                onPressed: () {
                  refreshAction();
                },
                child: const Text('Add Task'));
      },
    );
  }

  Widget ToDoAddTextfield({required TextEditingController controller}) {
    return BlocBuilder<ToDoCubit, ToDoState>(
      builder: (context, state) {
        return SizedBox(
          width: 380,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Wpisz nazwe zadania"),
            onChanged: (name) {
              context.read<ToDoCubit>().nameChanged(name);
            },
          ),
        );
      },
    );
  }
}
