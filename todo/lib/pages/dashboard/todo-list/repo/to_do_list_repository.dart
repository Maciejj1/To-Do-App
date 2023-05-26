import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/pages/dashboard/todo-list/repo/IToDoRepository.dart';
import 'package:todo/pages/dashboard/todo-list/service/to_do_list_model.dart';

class ToDoRepository extends ITodoRepository {
  // final firebase_firestore.FirebaseFirestore _firebaseFirestore;

  // ToDoRepository({firebase_firestore.FirebaseFirestore? firebaseFirestore})
  //     : _firebaseFirestore =
  //           firebaseFirestore ?? firebase_firestore.FirebaseFirestore.instance;

  // Future<void> addTask(
  //     {required String taskName,
  //     required bool taskClosed,
  //     required Timestamp taskDate,
  //     required int id}) async {
  //   try {
  //     await _firebaseFirestore.collection('tasks').add({
  //       'taskName': taskName,
  //       'taskClosed': taskClosed,
  //       'taskDate': taskDate,
  //       'id': id
  //     });
  //   } catch (_) {}
  // }

  // Future<void> removeTask() async {
  //   await _firebaseFirestore.collection('tasks').doc(todo.id).delete();
  // }

  Future<List<ShowTaskModel>> getTasks() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('tasks');
    try {
      QuerySnapshot snapshot = await collectionReference.get();
      if (snapshot.docs.isNotEmpty) {
        List<ShowTaskModel> tasksList = snapshot.docs
            .map((DocumentSnapshot document) =>
                ShowTaskModel.fromJson(document.data() as Map<String, dynamic>))
            .toList();
        return tasksList;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  final String _collectionPath = 'tasks';
  final String _orderedField = 'createdAt';

  @override
  Future<List<Todo>> getAllTodos() async {
    List<Todo> todos = [];

    final result = await firestore
        .collection(_collectionPath)
        .orderBy(_orderedField)
        .get();
    for (var snapshot in result.docs) {
      Todo newTodo = Todo.fromJson(snapshot.data());
      newTodo.id = snapshot.id;
      todos.add(newTodo);
    }
    return todos;
  }

  @override
  Future<List<Todo>> getClosedTodos() async {
    List<Todo> closedtodos = [];
    Todo? todo;
    final result = await firestore
        .collection(_collectionPath)
        .where(todo!.status == 1)
        .get();
    for (var snapshot in result.docs) {
      Todo newTodo = Todo.fromJson(snapshot.data());
      newTodo.id = snapshot.id;
      closedtodos.add(newTodo);
    }
    return closedtodos;
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await firestore.collection(_collectionPath).add(todo.toJson());
  }

  @override
  Future<void> removeTodo(Todo todo) async {
    await firestore.collection(_collectionPath).doc(todo.id).delete();
  }

  @override
  Future<void> closeTodo(Todo todo) async {
    await firestore
        .collection(_collectionPath)
        .doc(todo.id)
        .update({'status': 1});
  }
}
