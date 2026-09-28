import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/services/IDataSource.dart';
import 'package:todo_list/services/SQLDataSource.dart';
import 'package:todo_list/views/todo_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.putAsync<IDataSource>(() => SQLDataSource.createAsync()).whenComplete(
    () => runApp(
      ChangeNotifierProvider(
        create: (context) => TodoList(),
        child: const TodoApp(),
      ),
    ),
  );
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
                    Provider.of<TodoList>(context, listen: false).add(
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
        actions: [
          Consumer<TodoList>(
            builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text('${model.uncompletedCount} tasks left'),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer<TodoList>(
          //Consumer will automatically redraw the UI whenever notifyListeners() is called
          builder: (context, model, child) {
            return RefreshIndicator(
              // RefreshIndicator is the pull down to refresh function
              // In this case, whenever we pull down the screen, the app gets the Todo List from the datasource
              // onRefresh: model (model is the TodoList).refresh calls the refresh() in TodoList where it gets data from datasource
              onRefresh: model.refresh,
              child: ListView.builder(
                itemCount: model.todoCount,
                itemBuilder: (BuildContext context, int i) {
                  return Dismissible(
                    key: GlobalKey(),
                    onDismissed: (direction) {
                      Provider.of<TodoList>(
                        context,
                        listen: false,
                      ).delete(model.todos[i]);
                      // This calls delete() in TodoList which has notifyListeners() and would trigger this whole Consumer to redraw
                      // Effectively update the todo list on screeen to reflect the deleted todo
                    },
                    child: TodoWidget(todo: model.todos[i]),
                  );
                },
              ),
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
