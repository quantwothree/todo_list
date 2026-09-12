import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'dart:collection';

class TodoList extends ChangeNotifier {
  final List<Todo> _todos = <Todo>[];
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);
  int get todoCount => _todos.length;

  // => is a shorthand for return in lambda functions

  void add(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void delete(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }

  void removeAll() {
    _todos.clear();
    notifyListeners();
  }

  void update(Todo todo) {
    int index = _todos.indexWhere(
      (element) => element.name.toLowerCase() == todo.name.toLowerCase(),

      // This is a lambda function where it doesn't need a function name
      // Hence we can only see the parameters part of it ie. (element)
      // This lambda function is trying to find the index of the todo getting passed into Update()
      // By using the in built indexWhere() which loops through the _todos list
      // Comparing the names of each item in the list to the name of the todo passed into Update()
      // Then returns its index instead of the object itself (because thats how indexWhere() behave)
    );
    _todos[index] = todo;
    notifyListeners();
  }

  int get uncompletedCount {
    return _todos.where((element) => element.complete == false).length;
  }
}
