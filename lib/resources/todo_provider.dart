import '../models/todo_model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoProvider {
  List<dynamic> _todoList = [];

  Future<List<dynamic>> fetchToDo() async {
    final result = await Firestore.instance.collection('todos').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((document) {
      var data = {
        'title': document.data['title'],
        'done': document.data['done'],
        'id': document.data['id'],
        'docId': document.documentID,
      };

      _todoList.add(data);
    });

    return _todoList;
  }

  Future<List<dynamic>> toggleDone(String docId) async {
    final document = Firestore.instance.collection('todos').document(docId);
    final currentDone = await document.get().then((v) {
      return v.data['done'];
    });
    await document.updateData({'done': !currentDone});

    _todoList = [];
    return fetchToDo();
  }
}
