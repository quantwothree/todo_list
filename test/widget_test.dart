import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/models/todo_list.dart';
import 'package:todo_list/services/APIDataSource.dart';
import 'package:todo_list/services/IDataSource.dart';
import 'package:todo_list/services/MockDataSource.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    Get.putAsync<IDataSource>(() => MockDataSource.createAsync());

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => TodoList(),
        child: const TodoApp(),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.enterText(,"Some task");
    await tester.enterText(,"Some description");
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
