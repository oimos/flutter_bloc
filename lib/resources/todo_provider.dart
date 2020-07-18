import '../models/todo_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoProvider {
  List<TodoModel> _todoList = [];

  Future<List<TodoModel>> fetchToDo() async {
    final result = await Firestore.instance.collection('todos').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((document) {
      _todoList.add(TodoModel(
        document.data['title'] as String,
        document.data['done'] as bool,
        document.data['id'] as int,
        document.data['docId'] as String,
      ));
    });

    return _todoList;
  }

  Future<List<TodoModel>> toggleDone(String docId) async {
    final document = Firestore.instance.collection('todos').document(docId);
    final currentDone = await document.get().then((v) {
      return v.data['done'];
    });
    await document.updateData({'done': !currentDone});

    _todoList = [];
    return fetchToDo();
  }
}
