import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/services/APIDataSource.dart';
import 'package:todo_list/services/IDataSource.dart';
import 'package:todo_list/services/MockDataSource.dart';

void main() {
  setUp(() async {
    final mockDataSource = await MockDataSource.createAsync();
    Get.put<IDataSource>(mockDataSource);
  });

  testWidgets('Browse: should render the existing todos', (
    WidgetTester tester,
  ) async {
    // Add directly to the database to test if app can redner the list on startup
    final database = Get.find<IDataSource>();
    await database.add(
      Todo(id: '1', name: 'widget test', description: 'please work'),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => TodoList(),
        child: const TodoApp(),
      ),
    );

    // pumpAndSettle() waits for the UI to finish rendering
    await tester.pumpAndSettle();

    expect(find.text('widget test'), findsOneWidget);
  });

  testWidgets('Add: should render a new todo', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => TodoList(),
        child: const TodoApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap the add button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Enter the text field
    await tester.enterText(find.byType(TextField).first, 'newly added todo');

    // Tap save and wait for the UI to update
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('newly added todo'), findsOneWidget);
  });

  testWidgets('Delete: swiping should remove a todo', (
    WidgetTester tester,
  ) async {
    // Add directly to the database
    final database = Get.find<IDataSource>();
    await database.add(
      Todo(id: '2', name: 'swipe here', description: 'to be deleted'),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => TodoList(),
        child: const TodoApp(),
      ),
    );
    await tester.pumpAndSettle();

    // because  UI uses the Dismissible widget, we must simulate a user swiping horizontally
    // tester.drag clicks the item and pulls it X pixels left or right and Y pixels up or down
    // -10000 means left by 10000 pixels - 0 means stay perfectly straight when swipe
    await tester.drag(find.text('swipe here'), const Offset(-10000, 0));
    await tester.pumpAndSettle();

    expect(find.text('swipe here'), findsNothing);
  });

  testWidgets('Counter: add a task should update the counter', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => TodoList(),
        child: const TodoApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('0 tasks left'), findsOneWidget);

    // Add a task
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Eneter details
    await tester.enterText(find.byType(TextField).first, 'count this');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('1 tasks left'), findsOneWidget);
  });
}
