import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/IDataSource.dart';

class HiveDataSource implements IDataSource {
  Future initialise() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    await Hive.openBox<Todo>('todos');
  }

  static Future<IDataSource> createAsync() async {
    HiveDataSource dataSource = HiveDataSource();
    await dataSource.initialise();
    return dataSource;
  }

  @override
  Future<List<Todo>> browse() async {
    Box<Todo> box = Hive.box('todos');
    return box.values.toList();
  }

  @override
  Future<bool> add(Todo todo) async {
    Box<Todo> box = Hive.box('todos');
    int key = await box.add(todo);
    Todo updatedTodo = todo.copyWith(id: key.toString());
    return await edit(updatedTodo);
  }

  @override
  Future<bool> edit(Todo todo) async {
    Box<Todo> box = Hive.box('todos');
    int key = int.parse(todo.id!);
    //because id is String? (can be null) the ! promise that here it's not null
    // so that it can be passed into int.parse()
    await box.put(key, todo);
    return true;
  }

  @override
  Future<bool> delete(Todo todo) async {
    Box<Todo> box = Hive.box('todos');
    int key = int.parse(todo.id!);
    await box.delete(key);
    return true;
  }

  @override
  Future<Todo?> read(String id) async {
    Box<Todo> box = Hive.box('todos');
    int key = int.parse(id);
    return box.get(key);
  }
}
