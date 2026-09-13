import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todo_list.dart';

class TodoWidget extends StatefulWidget {
  final Todo todo;
  const TodoWidget({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   padding: const EdgeInsets.all(5),
    //   child: Text(widget.todo.name),

    return Checkbox(
      value: widget.todo.complete,
      onChanged: (bool? value) {
        setState(() {
          widget.todo.complete = value ?? false;
        });

        Provider.of<TodoList>(context, listen: false).update(widget.todo);
      },

      // Note on onChanged: {required void Function(bool?)? onChanged}
      // required does not mean it must have a real value
      // it simply means you must write this property when using onChanged
      // so then the last ? means this entire Function(bool?)? can be null
      // eg. you can write onChanged: null
    );
  }
}
