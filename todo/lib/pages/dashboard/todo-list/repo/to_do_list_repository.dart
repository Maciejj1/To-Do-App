import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/pages/dashboard/todo-list/service/to_do_list_model.dart';

class ToDoRepository {
  final firebase_firestore.FirebaseFirestore _firebaseFirestore;

  ToDoRepository({firebase_firestore.FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore =
            firebaseFirestore ?? firebase_firestore.FirebaseFirestore.instance;

  Future<void> addTask(
      {required String taskName,
      required bool taskClosed,
      required Timestamp taskDate,
      required int id}) async {
    try {
      await _firebaseFirestore.collection('tasks').add({
        'taskName': taskName,
        'taskClosed': taskClosed,
        'taskDate': taskDate,
        'id': id
      });
    } catch (_) {}
  }

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
}
