import '../models/todo_model.dart';

import 'todo_provider.dart';

class Repository {
  final provider = new TodoProvider();

  Future<List<dynamic>> fetchAllProvider() => provider.fetchToDo();

  Future<List<dynamic>> toggleDone(docId) => provider.toggleDone(docId);
}
