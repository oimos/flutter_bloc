import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import '../models/todo_model.dart';
import '../resources/repository.dart';

class TodoBloc {
  final _repository = Repository();
  final _allTodoFetcher = PublishSubject<List<dynamic>>();

  Stream<List<dynamic>> get allTodo => _allTodoFetcher.stream;

  fetchAllTodos() async {
    List<dynamic> toDoModelList = await _repository.fetchAllProvider();

    print('toDoModelList');
    print(toDoModelList);

    _allTodoFetcher.sink.add(toDoModelList);
  }

  toggleDone(String docId) async {
    List<dynamic> toDoModelList = await _repository.toggleDone(docId);
    _allTodoFetcher.sink.add(toDoModelList);
  }

  dispose() {
    _allTodoFetcher.close();
  }
}
