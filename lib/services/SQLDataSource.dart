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

  //BREAD
  @override
  Future<List<Todo>> browse() async {
    List<Map<String, dynamic>> maps = await _database.query('todos');
    return List.generate(maps.length, (index) {
      return Todo.fromMap(maps[index]);
    });
  }

  @override
  Future<Todo?> read(String id) async {
    List<Map<String, dynamic>> maps = await _database.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    Todo mapToRead = Todo.fromMap(maps.first);
    return mapToRead;
  }

  @override
  Future<bool> edit(Todo model) async {
    Map<String, dynamic> map = model.toMap();
    await _database.update(
      'todos',
      map,
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return true;
  }

  @override
  Future<bool> add(Todo model) async {
    Map<String, dynamic> mapToInsert = model.toMap().remove('id');
    await _database.insert('todos', mapToInsert);
    return true;
  }

  @override
  Future<bool> delete(Todo model) async {
    String? id = model.id;
    await _database.delete('todos', where: 'id = ?', whereArgs: [id]);
    return true;
  }
}
