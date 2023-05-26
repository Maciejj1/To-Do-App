// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo/pages/dashboard/todo-list/repo/to_do_list_repository.dart';

import '../service/to_do_list_model.dart';

part 'to_do_list_event.dart';
part 'to_do_list_state.dart';

class ToDoListBloc extends Bloc<ToDoListEvent, ToDoListState> {
  final ToDoRepository toDoRepository;

  ToDoListBloc(this.toDoRepository) : super(ToDoListLoadingState()) {
    on<LoadToDoList>((event, emit) async {
      print('pobieram');
      emit(ToDoListLoadingState());
      try {
        final tasks = await toDoRepository.getTasks();
        emit(ToDoListLoadedState(tasks));
      } catch (e, stacktrace) {
        print(e.toString());
        print(stacktrace.toString());
        emit(ToDoListErrorState(e.toString()));
      }
    });
    on<TaskAdded>((event, emit) async {
      emit(ToDoListLoadingState());
      try {
        final tasks = await toDoRepository.getTasks();
        emit(ToDoListLoadedState(tasks));
      } catch (e, stacktrace) {
        print(e.toString());
        print(stacktrace.toString());
        emit(ToDoListErrorState(e.toString()));
      }
    });
  }
}

// class ToDoListBloc extends Bloc<ToDoListEvent, ToDoListState> {
//   @override
//   ToDoListState get initalState => ToDoListInitial();

//   void onCreate(TaskModel task) {
//     add(CreateToDo(taskModel: task));
//   }

//   void onFetch(TaskModel task) {
//     add(LoadToDoList());
//   }

//   void onUpdate(TaskModel task) {
//     add(UpdateToDo(taskModel: task));
//   }

//   void onDelete(TaskModel task) {
//     add(DeleteToDo(taskModel: task));
//   }

//   void onClear(TaskModel task) {
//     add(ClearToDo());
//   }

//   @override
//   Stream<ToDoListState> mapEventToState(ToDoListEvent event,)async{
//    if (event is CreateToDo) {
//       yield state.copyWith(status: ToDoListStatus.submitting);

//       try {
//         await ToDoRepository.addTask(
//           taskName: event.taskName,
//           taskClosed: event.taskClosed,
//           taskDate: event.taskDate,
//           id: event.id,
//         );

//         yield state.copyWith(status: ToDoListStatus.success);
//       } catch (_) {
//         yield state.copyWith(status: ToDoListStatus.error);
//       }
//     }
//   }
//   }
// }
