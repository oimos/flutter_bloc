import 'package:flutter/material.dart';
import '../ui/todo_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SceneryList(),
      ),
    );
  }
}
