part of 'to_do_list_bloc.dart';

@immutable
abstract class ToDoListEvent extends Equatable {
  const ToDoListEvent();
}

class LoadToDoList extends ToDoListEvent {
  @override
  List<Object?> get props => [];
}

class TaskAdded extends ToDoListEvent {
  @override
  List<Object?> get props => [];
}

// class CreateToDo extends ToDoListEvent {
//   TaskModel taskModel;
//   CreateToDo({required this.taskModel});
//   @override
//   List<Object?> get props => [taskModel];
// }

// class DeleteToDo extends ToDoListEvent {
//   TaskModel taskModel;
//   DeleteToDo({required this.taskModel});
//   @override
//   List<Object?> get props => [taskModel];
// }

// class UpdateToDo extends ToDoListEvent {
//   TaskModel taskModel;
//   UpdateToDo({required this.taskModel});
//   @override
//   List<Object?> get props => [taskModel];
// }
// class ClearToDo extends ToDoListEvent {
//   @override
//   // TODO: implement props
//   List<Object?> get props => throw UnimplementedError();
// }