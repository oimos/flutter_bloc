import 'dart:async';
import 'package:flutterbloc/models/todo_model.dart';
import 'package:flutterbloc/resources/repository.dart';

class TodoBloc {
  final _repository = Repository();

  // ignore: close_sinks
  final StreamController<List<TodoModel>> _streamController =
      StreamController<List<TodoModel>>();
  Stream<List<TodoModel>> get stream => _streamController.stream;

  fetchAllTodos() async {
    List<TodoModel> toDoModelList = await _repository.fetchAllProvider();
    _streamController.sink.add(toDoModelList);
  }

  toggleDone(String docId) async {
    List<TodoModel> toDoModelList = await _repository.toggleDone(docId);
    _streamController.sink.add(toDoModelList);
  }

  dispose() {
    _streamController.close();
  }
}
