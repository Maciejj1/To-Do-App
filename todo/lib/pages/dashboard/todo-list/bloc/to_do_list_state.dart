part of 'to_do_list_bloc.dart';

@immutable
abstract class ToDoListState extends Equatable {}

class ToDoListLoadingState extends ToDoListState {
  @override
  List<Object?> get props => [];
}

class ToDoListLoadedState extends ToDoListState {
  final List<ShowTaskModel> tasks;

  ToDoListLoadedState(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class ToDoListErrorState extends ToDoListState {
  final String error;

  ToDoListErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
