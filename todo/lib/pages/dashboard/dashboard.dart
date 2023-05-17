import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:todo/config/bloc/app_bloc.dart';
import 'package:todo/config/helpers/to_do_icons_icons.dart';
import 'package:todo/config/helpers/todo-appBar.dart';
import 'package:todo/config/helpers/todo-bottomNavBar.dart';
import 'package:todo/config/helpers/todo-drawer.dart';
import 'package:todo/pages/dashboard/todo-list/bloc/to_do_list_bloc.dart';
import 'package:todo/pages/dashboard/todo-list/cubit/to_do_list_cubit.dart';
import 'package:todo/pages/dashboard/todo-list/repo/to_do_list_repository.dart';
import 'package:todo/pages/dashboard/todo-list/service/to_do_list_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:todo/pages/dashboard/todo-list/view/todo.dart';
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
        backgroundColor: Color(0xFF6200EE),
        child: Icon(ToDoIcons.icon__add_),
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
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
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
                              todoNumber: '${index}',
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
    final TextEditingController _controller = TextEditingController();
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
                icon: Icon(Icons.close)),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text('Dodaj nowe zadanie'),
        SizedBox(
          height: 20,
        ),
        ToDoAddTextfield(
          controller: _controller,
        ),
        SizedBox(
          height: 20,
        ),
        ToDoAddButton(
          refreshAction: () {
            context.read<ToDoCubit>().addTodo(Todo(
                todoText: _controller.text.trim(),
                createdAt: Timestamp.now(),
                status: 0));
            setState(() {});
            context.read<ToDoCubit>().getAllTodo();
          },
          controller: _controller,
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
                child: Text('Add Task'));
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
            decoration: InputDecoration(hintText: "Wpisz nazwe zadania"),
            onChanged: (name) {
              context.read<ToDoCubit>().nameChanged(name);
            },
          ),
        );
      },
    );
  }
  // void showAdToDoPopup() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Scaffold(
  //           backgroundColor: Colors.transparent,
  //           resizeToAvoidBottomInset: false,
  //           body: SizedBox(
  //             height: MediaQuery.of(context).size.height,
  //             child: SingleChildScrollView(
  //               child: SizedBox(
  //                 child: Dialog(
  //                   insetPadding: const EdgeInsets.symmetric(
  //                       horizontal: 0, vertical: 290),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20.0),
  //                   ),
  //                   clipBehavior: Clip.antiAlias,
  //                   child: Center(
  //                     child: Material(
  //                       borderRadius: BorderRadius.circular(16),
  //                       child: Container(
  //                         height: 250,
  //                         width: MediaQuery.of(context).size.width,
  //                         child: Column(
  //                           children: [
  //                             BlocProvider(
  //                               create: (context) => ToDoCubit(),
  //                               child: ToDoForm(
  //                                 todoAction: _refreshAction(),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
}

// class ToDoForm extends StatefulWidget {
//   ToDoForm({
//     super.key,
//   });

//   @override
//   State<ToDoForm> createState() => _ToDoFormState();
// }

// class _ToDoFormState extends State<ToDoForm> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // return BlocListener<ToDoCubit, ToDoState>(
//     //   listener: (context, state) {},
//     //   child: Column(
//     return Column(
//       children: [
//         Row(
//           children: [
//             IconButton(
//                 onPressed: () {
//                   setState(() {});
//                   Navigator.pop(context);
//                   context.read<ToDoCubit>().getAllTodo();
//                 },
//                 icon: Icon(Icons.close)),
//           ],
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Text('Dodaj nowe zadanie'),
//         SizedBox(
//           height: 20,
//         ),
//         ToDoAddTextField(
//           controller: _controller,
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         ToDoAddButton(
//           controller: _controller,
//         )
//       ],
//     );
//     // );
//   }
// }

// class ToDoAddTextField extends StatelessWidget {
//   ToDoAddTextField({super.key, required this.controller});
//   final TextEditingController controller;
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ToDoCubit, ToDoState>(
//       builder: (context, state) {
//         return SizedBox(
//           width: 380,
//           child: TextFormField(
//             controller: controller,
//             decoration: InputDecoration(hintText: "Wpisz nazwe zadania"),
//             onChanged: (name) {
//               context.read<ToDoCubit>().nameChanged(name);
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class ToDoAddButton extends StatefulWidget {
//   const ToDoAddButton({
//     super.key,
//     required this.controller,
//   });
//   final TextEditingController controller;

//   @override
//   State<ToDoAddButton> createState() => _ToDoAddButtonState();
// }

// class _ToDoAddButtonState extends State<ToDoAddButton> {
//   @override
//   Widget build(BuildContext context) {
//     Todo todo;

//     return BlocBuilder<ToDoCubit, ToDoState>(
//       builder: (context, state) {
//         return state is ToDoLoading
//             ? const CircularProgressIndicator.adaptive()
//             : ElevatedButton(
//                 onPressed: () {
//                   context.read<ToDoCubit>().addTodo(Todo(
//                       todoText: widget.controller.text.trim(),
//                       createdAt: Timestamp.now(),
//                       status: 0));
//                 },
//                 child: Text('Add Task'));
//       },
//     );
//   }
// }
