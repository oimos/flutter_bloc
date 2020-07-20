import 'package:flutter/material.dart';
import 'package:flutterbloc/blocs/todo_bloc.dart';
import 'package:flutterbloc/models/todo_model.dart';

class TodoList extends StatefulWidget {
  TodoList({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _bloc = TodoBloc();

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bloc.fetchAllTodos();

    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo 一覧'),
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
              stream: _bloc.stream,
              initialData: null,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data != null
                      ? _buildList(snapshot)
                      : Container();
                } else if (snapshot.hasError) {
                  return Text('エラーが発生しました' + snapshot.error.toString());
                } else {
                  return Dialog(
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        new CircularProgressIndicator(),
                        new Text("読み込み中"),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(AsyncSnapshot<List<TodoModel>> snapshot) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        TodoModel model = snapshot.data[index];
        return _toDoItem(
          model.title,
          model.done,
          model.id,
          model.docId,
        );
      },
      itemCount: snapshot.data.length,
    );
  }

  Widget _toDoItem(String title, bool done, int id, String docId) {
    return CheckboxListTile(
      title: Text(title),
      value: done,
      onChanged: (bool value) {
        print('docId');
        _bloc.toggleDone(docId);
      },
    );
  }
}
