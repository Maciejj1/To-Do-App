import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/pages/dashboard/todo-list/bloc/to_do_list_bloc.dart';
import 'package:todo/pages/dashboard/todo-list/repo/IToDoRepository.dart';
import 'package:todo/pages/dashboard/todo-list/repo/to_do_list_repository.dart';
import 'package:todo/pages/dashboard/todo-list/service/to_do_list_model.dart';

part 'to_do_list_state.dart';

// class ToDoListCubit extends Cubit<ToDoListtState> {
//   final ToDoRepository _toDoRepository;
//   final ToDoListBloc _toDoListBloc; // Dodaj to
//   ToDoListCubit(this._toDoRepository, this._toDoListBloc)
//       : super(ToDoListtState.initial());
// void nameChanged(String value) {
//   emit(state.copyWith(name: value, status: ToDoListStatus.initial));
// }

//   Future<void> addTask() async {
//     if (state.status == ToDoListStatus.submitting) return;
//     emit(state.copyWith(status: ToDoListStatus.submitting));

//     try {
//       ToDoListBloc(_toDoRepository).add(LoadToDoList());
//       await _toDoRepository.addTask(
//           taskName: state.name,
//           taskClosed: state.notClosed,
//           taskDate: state.date,
//           id: state.id);
//       _toDoListBloc.add(TaskAdded()); // Dodaj to

//       emit(state.copyWith(status: ToDoListStatus.succes));
//     } catch (_) {}
//   }
// }
class ToDoCubit extends Cubit<ToDoState> {
  ToDoCubit({ITodoRepository? todoRepository})
      : _todoRepository = todoRepository ?? ToDoRepository(),
        super(ToDoInitial());
  final ITodoRepository _todoRepository;

  Future<void> getAllTodo() async {
    emit(ToDoLoading());
    final results = await _todoRepository.getAllTodos();
    emit(ToDoSucces(todos: results));
  }

  Future<void> getClosedTodo() async {
    emit(ToDoLoading());
    final results = await _todoRepository.getClosedTodos();
    emit(ToDoSucces(todos: results));
  }

  Future<void> addTodo(Todo todo) async {
    if (todo.todoText.isEmpty) return;
    emit(ToDoLoading());
    await _todoRepository.addTodo(todo);
    final results = await _todoRepository.getAllTodos();
    emit(ToDoSucces(todos: results));
  }

  Future<void> removeTodo(Todo todo) async {
    if (todo.todoText.isEmpty) return;
    emit(ToDoLoading());
    await _todoRepository.removeTodo(todo);
    final results = await _todoRepository.getAllTodos();
    emit(ToDoSucces(todos: results));
  }

  Future<void> closedTodo(Todo todo) async {
    if (todo.todoText.isEmpty) return;
    emit(ToDoLoading());
    await _todoRepository.closeTodo(todo);
    final results = await _todoRepository.getAllTodos();
    emit(ToDoSucces(todos: results));
  }

  void nameChanged(String value) {
    emit(ToDoInitial());
  }
}
