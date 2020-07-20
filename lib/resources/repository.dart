import 'package:flutterbloc/models/todo_model.dart';
import 'package:flutterbloc/resources/todo_provider.dart';

class Repository {
  final provider = new TodoProvider();

  Future<List<TodoModel>> fetchAllProvider() => provider.fetchToDo();

  Future<List<TodoModel>> toggleDone(docId) => provider.toggleDone(docId);
}
