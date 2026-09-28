import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:todo_list/models/todo.dart';
import 'dart:collection';
import 'package:todo_list/services/IDataSource.dart';

class TodoList extends ChangeNotifier {
  final List<Todo> _todos = <Todo>[];
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  // => is a shorthand for return in lambda functions

  TodoList() {
    refresh();
  } // Constructor that calls refresh() to get Todos from datasource when TodoList is instantiated

  Future<void> add(Todo todo) async {
    IDataSource dataSource = Get.find();
    await dataSource.add(todo);
    await refresh();
  }

  Future<void> delete(Todo todo) async {
    IDataSource dataSource = Get.find();
    await dataSource.delete(todo);
    await refresh();
  }

  void removeAll() {
    _todos.clear();
    notifyListeners();
  }

  Future<void> update(Todo todo) async {
    IDataSource dataSource = Get.find();
    await dataSource.edit(todo);
    await refresh();
  }

  int get uncompletedCount {
    return _todos.where((element) => element.complete == false).length;
  }

  Future<List<Todo>> refresh() async {
    IDataSource dataSource = Get.find();
    _todos.clear();
    _todos.addAll(await dataSource.browse());
    notifyListeners();
    return _todos;
  }
}
