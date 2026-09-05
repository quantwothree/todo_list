import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple To Do List',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const TodoHomePage(title: 'Simple To Do List Homepage'),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key, required this.title});
  final String title;

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Todo> todos = <Todo>[
    Todo(name: "Shopping", description: "Buy milk"),
    Todo(name: "Paint", description: "Mona Lisa"),
    Todo(name: "Dance", description: "Tango"),
  ];

  final TextEditingController _controlName = TextEditingController();
  final TextEditingController _controlDescription = TextEditingController();

  void _openAddTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
                child: Text("Name"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: TextFormField(controller: _controlName),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Text("Description"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 8),
                child: TextFormField(controller: _controlDescription),
              ),
              ElevatedButton(
                child: const Text("Submit"),
                onPressed: () {
                  setState(() {
                    todos.add(
                      Todo(
                        name: _controlName.text,
                        description: _controlDescription.text,
                      ),
                    );
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int i) {
            return Container(
              padding: const EdgeInsets.all(5),
              child: Text(todos[i].toString()),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTodo,
        tooltip: "Add something",
        child: const Icon(Icons.add),
      ),
    );
  }
}
