import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  const TodoWidget({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Text(widget.todo.name),
    );
  }
}
