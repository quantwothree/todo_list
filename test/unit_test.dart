import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/services/IDataSource.dart';
import 'package:todo_list/services/MockDataSource.dart';

void main() {
  late TodoList todoList;

  setUp(() async {
    final mockDataSource = await MockDataSource.createAsync();
    Get.put<IDataSource>(mockDataSource);

    todoList = TodoList();
  });

  tearDown(() {
    Get.reset();
  });

  test('Browse: should initially return empty', () async {
    final numberOfTodos = todoList.todoCount;
    expect(numberOfTodos, 0);
  });

  test('Add: should insert a task', () async {
    final newTodo = Todo(
      id: '1',
      name: 'test add',
      description: 'this should be added',
    );
    await todoList.add(newTodo);
    expect(todoList.todoCount, 1);
  });

  test('Update: should update the details of a todo', () async {
    final originalTodo = Todo(
      id: '99',
      name: 'not satan',
      description: 'change me',
    );
    await todoList.add(originalTodo);

    expect(todoList.todoCount, 1);

    final updatedTodo = Todo(id: '666', name: 'satan', description: 'hahaha');

    await todoList.update(updatedTodo);

    expect(todoList.todoCount, 1); // Ensure it didn't add a second todo
    // expect info to match?
  });

  test('Delete: should remove the task from the list', () async {
    final todoToDelete = Todo(
      id: '666',
      name: 'satan',
      description: 'trash me',
    );
    await todoList.add(todoToDelete);

    expect(todoList.todoCount, 1);

    await todoList.delete(todoToDelete);

    expect(todoList.todoCount, 0);
  });
}
