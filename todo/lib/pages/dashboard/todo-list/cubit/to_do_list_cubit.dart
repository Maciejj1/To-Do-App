import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/pages/dashboard/todo-list/bloc/to_do_list_bloc.dart';
import 'package:todo/pages/dashboard/todo-list/repo/to_do_list_repository.dart';

part 'to_do_list_state.dart';

class ToDoListCubit extends Cubit<ToDoListtState> {
  final ToDoRepository _toDoRepository;
  ToDoListCubit(this._toDoRepository) : super(ToDoListtState.initial());
  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: ToDoListStatus.initial));
  }

  Future<void> addTask() async {
    if (state.status == ToDoListStatus.submitting) return;
    emit(state.copyWith(status: ToDoListStatus.submitting));

    try {
      ToDoListBloc(_toDoRepository).add(LoadToDoList());
      await _toDoRepository.addTask(
          taskName: state.name,
          taskClosed: state.notClosed,
          taskDate: state.date,
          id: state.id);
      emit(state.copyWith(status: ToDoListStatus.succes));
    } catch (_) {}
  }
}
