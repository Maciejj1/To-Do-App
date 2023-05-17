import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:todo/pages/dashboard/todo-list/cubit/to_do_list_cubit.dart';
import 'package:todo/pages/dashboard/widgets/todo_card.dart';

import '../../config/helpers/todo-appBar.dart';
import '../../config/helpers/todo-bottomNavBar.dart';
import '../../config/helpers/todo-drawer.dart';

class ClosedTodos extends StatefulWidget {
  const ClosedTodos({Key? key}) : super(key: key);

  @override
  State<ClosedTodos> createState() => _ClosedTodosState();
}

class _ClosedTodosState extends State<ClosedTodos> {
  bool isChecked = false;
  var heart = Emoji('heart', '❤️');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 90,
            width: MediaQuery.of(context).size.width - 0,
            child: Center(child: blocBody()),
          ),
        ),
      ),
    );
  }

  Widget blocBody() {
    return BlocProvider(
      create: (context) => ToDoCubit()..getAllTodo(),
      child: BlocConsumer<ToDoCubit, ToDoState>(
        listener: (context, state) {},
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
                state.todos!.where((element) => element.status == 1).toList();
            return Padding(
              padding: EdgeInsets.all(10),
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                  });
                },
                children: [
                  for (int index = 1; index < todoList.length; index += 1)
                    ToDoCard(
                      key: ValueKey(todoList[index].id), // Assign a unique key
                      todo: todoList[index], todoNumber: '${index}',
                    ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
