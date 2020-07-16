import 'dart:ui';

import 'package:flutter/material.dart';
import '../blocs/todo_bloc.dart';
import '../models/todo_model.dart';

class SceneryList extends StatelessWidget {
  final _bloc = TodoBloc();

  @override
  Widget build(BuildContext context) {
    _bloc.fetchAllTodos();

    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo 一覧'),
      ),
      body: StreamBuilder(
          stream: _bloc.allTodo,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data != null ? _buildList(snapshot) : Container();
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
          }),
    );
  }

  Widget _buildList(AsyncSnapshot<List<dynamic>> snapshot) {
    return ListView.builder(
      itemBuilder: (_, index) {
        dynamic model = snapshot.data[index];
        return _toDoItem(
          model['title'],
          model['done'],
          model['id'],
          model['docId'],
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
        _bloc.toggleDone(docId);
      },
    );
  }
}
