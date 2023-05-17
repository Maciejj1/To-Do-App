import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/config/helpers/to_do_icons_icons.dart';
import 'package:todo/pages/dashboard/todo-list/cubit/to_do_list_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../todo-list/service/to_do_list_model.dart';

class ToDoCard extends StatelessWidget {
  const ToDoCard({super.key, required this.todo, required this.todoNumber});
  final Todo todo;
  final String todoNumber;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            height: 50,
            child: InkWell(
              onTap: () {},
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.all(
                                const Color(0xFF6200EE)),
                            value: todo.status == 0 ? false : true,
                            onChanged: (bool? value) {
                              context.read<ToDoCubit>().closedTodo(todo);
                            },
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(todoNumber)
                              // taskList[index].taskName),
                              ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text("❤️"),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(todo.todoText)
                                        // taskList[index].taskName),
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
                      child: Text(timeago
                          .format(DateTime.tryParse(
                              todo.createdAt.toDate().toString())!)
                          .toString()),
                    ),
                    IconButton(
                        onPressed: () {
                          context.read<ToDoCubit>().removeTodo(todo);
                        },
                        icon: Icon(
                          ToDoIcons.icon__trash_,
                          color: Colors.redAccent,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
