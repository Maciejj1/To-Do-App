import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/to_do_list_model.dart';

abstract class ITodoRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<Todo>> getAllTodos();
  Future<List<Todo>> getClosedTodos();
  Future<void> addTodo(Todo todo);
  Future<void> removeTodo(Todo todo);
  Future<void> closeTodo(Todo todo);
}
