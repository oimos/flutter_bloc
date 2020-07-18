import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../models/todo_model.dart';
import '../resources/repository.dart';

class TodoBloc {
  final _repository = Repository();
  final _allTodoFetcher = PublishSubject<List<TodoModel>>();

  Stream<List<TodoModel>> get allTodo => _allTodoFetcher.stream;

  fetchAllTodos() async {
    List<TodoModel> toDoModelList = await _repository.fetchAllProvider();
    _allTodoFetcher.sink.add(toDoModelList);
  }

  toggleDone(String docId) async {
    List<TodoModel> toDoModelList = await _repository.toggleDone(docId);
    _allTodoFetcher.sink.add(toDoModelList);
  }

  dispose() {
    _allTodoFetcher.close();
  }
}
