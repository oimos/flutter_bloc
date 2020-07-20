class TodoModel {
  final String title;
  final int id;
  final String docId;
  bool done;

  TodoModel({this.title, this.done, this.id, this.docId});

  set toggleState(bool done) => this.done = done;

  factory TodoModel.fromMap(Map data) {
    return TodoModel(
      title: data['title'] ?? '',
      done: data['done'] ?? false,
      id: data['id'] ?? 0,
      docId: data['docId'] ?? 'aaa',
    );
  }
}
