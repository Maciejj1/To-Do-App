import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/pages/dashboard/todo-list/bloc/to_do_list_bloc.dart';
import 'package:todo/pages/dashboard/todo-list/cubit/to_do_list_cubit.dart';
import 'package:todo/pages/dashboard/todo-list/repo/to_do_list_repository.dart';

import '../service/to_do_list_model.dart';

class ToDoScreen extends StatelessWidget {
  ToDoScreen({super.key});

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
