part of 'to_do_list_cubit.dart';

enum ToDoListStatus { initial, submitting, succes, error }

class ToDoListtState extends Equatable {
  final String name;
  final bool notClosed;
  final Timestamp date;
  final ToDoListStatus status;
  final int id;

  ToDoListtState(
      {required this.name,
      required this.status,
      required this.notClosed,
      required this.id,
      required this.date});

  factory ToDoListtState.initial() {
    return ToDoListtState(
        notClosed: true,
        id: 1,
        date: Timestamp.now(),
        name: '',
        status: ToDoListStatus.initial);
  }
  ToDoListtState copyWith({String? name, ToDoListStatus? status}) {
    return ToDoListtState(
        id: id,
        name: name ?? this.name,
        status: status ?? this.status,
        notClosed: notClosed,
        date: date);
  }

  @override
  List<Object> get props => [name, status];
}
