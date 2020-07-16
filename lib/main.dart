import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
    this.todoList,
  }) : super(key: key);
  final String title;
  final List<Map> todoList;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _bloc = CounterBloc();
  final _toDoBloc = ToDoBloc();

  int _counter = 0;
  List<dynamic> _todoList = [];

  void initializeState() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('todos').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((document) {
      setState(() {
        _todoList.add({
          'title': document.data['title'] as String,
          'done': document.data['done'] as bool,
        });
      });
    });
  }

  void _countDoneTask() {
    if (_todoList == null) return;
    int _numOfDone = 0;
    _todoList.forEach((item) {
      if (item['done']) {
        _numOfDone++;
      }
    });
    setState(() {
      _counter = _numOfDone;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _toDoBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _todoListWidgets() {
      List<Widget> todoListWidget = [];
      for (var i = 0; i < _todoList.length; i++) {
        final String title = _todoList[i]['title'];
        final bool done = _todoList[i]['done'];
        todoListWidget.add(
          new CheckboxListTile(
            activeColor: Colors.blue,
            title: Text(title),
            secondary: new Icon(
              Icons.thumb_up,
              color: done ? Colors.orange[700] : Colors.grey[500],
            ),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool val) {
              print(_todoList);
              setState(() {
                _todoList[i]['done'] = val;
                _countDoneTask();
              });
            },
            value: done,
          ),
        );
      }

      return todoListWidget;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                children: _todoListWidgets(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                '$_counter / ${_todoList.length}',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                _counter == _todoList.length ? '今日の仕事は終わり 💪' : '仕事がんばれ 😱',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Container(
              child: StreamBuilder<int>(
                  stream: _bloc.counter,
                  initialData: 100,
                  builder: (context, snapshot) {
                    return Text(
                      '${snapshot.data}',
                      style: Theme.of(context).textTheme.display1,
                    );
                  }),
            ),
            Container(
              child: StreamBuilder<List>(
                  stream: _toDoBloc.todo,
                  initialData: [
                    {
                      'title': 'default',
                      'done': false,
                    }
                  ],
                  builder: (context, snapshot) {
                    List<Widget> todoListWidget = [];
                    print('snapshot');
                    print(snapshot.data.runtimeType);
                    print(snapshot.data[0]);
                    print(snapshot.data[0]['title']);
//                    return Container();
                    for (var i = 0; i < snapshot.data.length; i++) {
                      final String title = snapshot.data[i]['title'];
                      final bool done = snapshot.data[i]['done'];
                      todoListWidget.add(
                        new CheckboxListTile(
                          activeColor: Colors.blue,
                          title: Text(title),
                          secondary: new Icon(
                            Icons.thumb_up,
                            color: done ? Colors.orange[700] : Colors.grey[500],
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool val) {
                            print(_todoList);
                            setState(() {
                              _todoList[i]['done'] = val;
                              _countDoneTask();
                            });
                          },
                          value: done,
                        ),
                      );
                    }

                    return Container(
                      child: Column(
                        children: todoListWidget,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _countDoneTask(),
          _bloc.increment.add(null),
          _toDoBloc.addTodo.add(null),
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CounterBloc {
  final _incrementController = StreamController<void>();
  final _countController = StreamController<int>();

  var _count = 0;
  CounterBloc() {
    _incrementController.stream.map((v) => _count++).pipe(_countController);
  }

  Sink<void> get increment => _incrementController.sink;
  Stream<void> get counter => _countController.stream;

  void dispose() async {
    await _incrementController.close();
    await _countController.close();
  }
}

class ToDoBloc {
  final _addToDoController = StreamController<void>();
  final _getToDoController = StreamController<List<Map>>();

  var _todoList = [];
  var _todoList_b = [];

  void init() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('todos').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((document) {
      _todoList.add({
        'title': document.data['title'] as String,
        'done': document.data['done'] as bool,
      });
    });
  }

  ToDoBloc() {
    _addToDoController.stream
        .map((v) => _todoList_b.add(_todoList))
        .pipe(_getToDoController);
  }

  Sink<void> get addTodo => _addToDoController.sink;
  Stream<void> get todo => _getToDoController.stream;

  void dispose() async {
    await _addToDoController.close();
    await _getToDoController.close();
  }
}
