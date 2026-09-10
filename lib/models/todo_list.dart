import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'dart:collection';

class TodoList extends ChangeNotifier {
  final List<Todo> _todos = <Todo>[];
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  void Add(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void Delete(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }

  void RemoveAll() {
    _todos.clear();
    notifyListeners();
  }
}
