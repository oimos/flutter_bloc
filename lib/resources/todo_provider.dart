import 'dart:async';
import 'package:flutterbloc/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoProvider {
  Future<List<TodoModel>> fetchToDo() async {
    final result = await Firestore.instance.collection('todos').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    List<TodoModel> _todoList = [];

    documents.forEach((document) {
      Map firebaseData = document.data;
      firebaseData['docId'] = document.documentID;
      _todoList.add(TodoModel.fromMap(firebaseData));
    });

    return _todoList;
  }

  Future<List<TodoModel>> toggleDone(String docId) async {
    final document = Firestore.instance.collection('todos').document(docId);
    final currentDone = await document.get().then((doc) {
      return doc.data['done'];
    });
    await document.updateData({'done': !currentDone});
    List<TodoModel> todoData = await fetchToDo();
    return todoData;
  }
}
