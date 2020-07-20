import 'dart:async';
import 'package:flutterbloc/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoProvider {
  List<TodoModel> _todoList = [];

  Future<List<TodoModel>> fetchToDo() async {
    final result = await Firestore.instance.collection('todos').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    _todoList = [];
    documents.forEach((document) {
      _todoList.add(TodoModel(
        document.data['title'] as String,
        document.data['done'] as bool,
        document.data['id'] as int,
        document.documentID,
      ));
    });

    return _todoList;
  }

  Future<List<TodoModel>> toggleDone(String docId) async {
    final document = Firestore.instance.collection('todos').document(docId);
    final currentDone = await document.get().then((doc) {
      return doc.data['done'];
    });
    await document.updateData({'done': !currentDone});
    return fetchToDo();
  }
}
