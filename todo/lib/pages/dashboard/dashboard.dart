import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:todo/config/bloc/app_bloc.dart';
import 'package:todo/config/helpers/todo-appBar.dart';
import 'package:todo/config/helpers/todo-bottomNavBar.dart';
import 'package:todo/config/helpers/todo-drawer.dart';
import 'package:todo/pages/dashboard/todo-list/bloc/to_do_list_bloc.dart';
import 'package:todo/pages/dashboard/todo-list/cubit/to_do_list_cubit.dart';
import 'package:todo/pages/dashboard/todo-list/repo/to_do_list_repository.dart';
import 'package:todo/pages/dashboard/todo-list/service/to_do_list_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:todo/pages/dashboard/todo-list/view/todo.dart';

class Dashboard extends StatefulWidget {
  static Page<void> page() => const MaterialPage<void>(child: Dashboard());
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isChecked = false;
  var heart = Emoji('heart', '❤️');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAdToDoPopup();
        },
      ),
      appBar: const TodoAppBar(),
      drawer: const TodoDrawer(),
      bottomNavigationBar: const ToDoBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
            child: SizedBox(
                height: MediaQuery.of(context).size.height - 90,
                width: MediaQuery.of(context).size.width - 20,
                child: blocBody())),
      ),
    );
  }

  Widget blocBody() {
    return BlocProvider(
      create: (context) => ToDoListBloc(ToDoRepository())..add(LoadToDoList()),
      child: BlocBuilder<ToDoListBloc, ToDoListState>(
        builder: (context, state) {
          if (state is ToDoListLoadingState) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is ToDoListErrorState) {
            return const Center(
              child: Text('Coś poszło nie tak'),
            );
          }

          if (state is ToDoListLoadedState) {
            List<ShowTaskModel> taskList = state.tasks;

            return ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (_, index) {
                Timestamp? timestamp =
                    taskList[index].taskTime ?? Timestamp.now();

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20, right: 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 50,
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
                                      value: taskList[index].taskClosed,
                                      onChanged: (bool? value) {},
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text("❤️"),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                      taskList[index].taskName!)
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
                                        timestamp.toDate().toString())!)
                                    .toString()),
                              ),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  void showAdToDoPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Dialog(
                    insetPadding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 290),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Center(
                      child: Material(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                      create: (context) =>
                                          ToDoListBloc(ToDoRepository())
                                            ..add(LoadToDoList())),
                                  BlocProvider<ToDoListCubit>(
                                      create: (_) => ToDoListCubit(
                                            ToDoRepository(),
                                          ))
                                ],
                                child: ToDoForm(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
