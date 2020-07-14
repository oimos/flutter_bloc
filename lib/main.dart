import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _countDoneTask(),
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
