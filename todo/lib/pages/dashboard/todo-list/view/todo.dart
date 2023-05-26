import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/pages/dashboard/todo-list/cubit/to_do_list_cubit.dart';

class ToDoScreen extends StatelessWidget {
  const ToDoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: BlocProvider<ToDoCubit>(
            create: (_) => ToDoCubit(),
            child: Column(),
          ),
        ),
      )),
    );
  }
}
