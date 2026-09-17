import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/IDataSource.dart';

class SQLDataSource implements IDataSource {
  late Database _database;

  Future initialise() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_data.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY, name TEXT, description TEXT, complete INTEGER)',
        );
      },
    );
  }

  static Future<IDataSource> createAsync() async {
    SQLDataSource dataSource = SQLDataSource();
    await dataSource.initialise();
    return dataSource;
  }

  @override
  Future<List<Todo>> browse() async {
    List<Map<String, dynamic>> maps = await _database.query('todos');
    return List.generate(maps.length, (index) {
      return Todo.fromMap(maps[index]);
    });
  }
}
