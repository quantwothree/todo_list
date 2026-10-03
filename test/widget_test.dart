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

    await tester.pumpAndSettle();

    expect(find.text('widget test'), findsOneWidget);
  });
}
