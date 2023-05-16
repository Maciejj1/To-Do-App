import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/pages/dashboard/todo-list/bloc/to_do_list_bloc.dart';
import 'package:todo/pages/dashboard/todo-list/cubit/to_do_list_cubit.dart';
import 'package:todo/pages/dashboard/todo-list/repo/to_do_list_repository.dart';

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
          child: BlocProvider<ToDoListCubit>(
            create: (_) => ToDoListCubit(
              ToDoRepository(),
            ),
            child: ToDoForm(),
          ),
        ),
      )),
    );
  }
}

class ToDoForm extends StatelessWidget {
  const ToDoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ToDoListCubit, ToDoListtState>(
      listener: (context, state) {
        if (state.status == ToDoListStatus.succes) {
          Navigator.of(context).pop(); // zamknięcie formularza dodawania
          ToDoListBloc(ToDoRepository())
            ..add(LoadToDoList()); // pobranie zaktualizowanej listy zadań
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
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
          ToDoAddTextField(),
          SizedBox(
            height: 20,
          ),
          ToDoAddButton()
        ],
      ),
    );
  }
}

class ToDoAddTextField extends StatelessWidget {
  const ToDoAddTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToDoListCubit, ToDoListtState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return SizedBox(
          width: 380,
          child: TextFormField(
            decoration: InputDecoration(hintText: "Wpisz nazwe zadania"),
            onChanged: (name) {
              context.read<ToDoListCubit>().nameChanged(name);
            },
          ),
        );
      },
    );
  }
}

class ToDoAddButton extends StatelessWidget {
  const ToDoAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToDoListCubit, ToDoListtState>(
      builder: (context, state) {
        return state.status == ToDoListStatus.submitting
            ? const CircularProgressIndicator.adaptive()
            : ElevatedButton(
                onPressed: () {
                  context.read<ToDoListCubit>().addTask();
                },
                child: Text('Add Task'));
      },
    );
  }
}
