import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/IDataSource.dart';

class MockDataSource implements IDataSource {
  final List<Todo> todos = [];

  Future initialise() async {}

  static Future<IDataSource> createAsync() async {
    return MockDataSource();
  }

  @override
  Future<bool> add(Todo todo) async {
    todos.add(todo);
    return true;
  }

  @override
  Future<List<Todo>> browse() async {
    return todos;
  }

  @override
  Future<bool> delete(Todo todo) async {
    return todos.remove(todo);
  }

  @override
  Future<bool> edit(Todo todo) async {
    int index = todos.indexWhere((x) => x.id == todo.id);
    if (index >= 0) {
      todos[index] = todo;
    }
    return (index >= 0);
  }

  @override
  Future<Todo?> read(String id) async {
    Todo todo = todos.firstWhere((x) => x.id == id);
    return todo;
  }
}
