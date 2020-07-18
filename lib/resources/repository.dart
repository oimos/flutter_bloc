import '../models/todo_model.dart';

import 'todo_provider.dart';

class Repository {
  final provider = new TodoProvider();

  Future<List<TodoModel>> fetchAllProvider() => provider.fetchToDo();

  Future<List<TodoModel>> toggleDone(docId) => provider.toggleDone(docId);
}
