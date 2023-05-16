import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? taskName;
  final String? taskId;
  final bool? taskClosed;
  final Timestamp? taskTime;

  const TaskModel(
      {this.taskName, required this.taskId, this.taskClosed, this.taskTime});

  static const empty = TaskModel(taskId: '');

  bool get isEmpty => this == TaskModel.empty;

  bool get isNotEmpty => this != TaskModel.empty;

  @override
  List<Object?> get props => [taskId, taskName, taskClosed, taskTime];
}

class ShowTaskModel {
  String? taskName;
  String? taskId;
  bool? taskClosed;
  Timestamp? taskTime;
  ShowTaskModel({this.taskName, this.taskId, this.taskClosed, this.taskTime});
  ShowTaskModel.fromJson(Map<String, dynamic> json) {
    taskId = json['taskId'];
    taskName = json['taskName'];
    taskClosed = json['taskClosed'];
    taskTime = json['taskTime'];
  }
}
