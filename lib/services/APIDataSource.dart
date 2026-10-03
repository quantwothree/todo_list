import 'package:todo_list/firebase_options.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/IDataSource.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class APIDataSource implements IDataSource {
  late FirebaseDatabase database;

  Future initialise() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    database = FirebaseDatabase.instance;
  }

  static Future<IDataSource> createAsync() async {
    APIDataSource dataSource = APIDataSource();
    await dataSource.initialise();
    return dataSource;
  }

  @override
  Future<List<Todo>> browse() async {
    //List<Todo> todos = <Todo>[];
    final DataSnapshot snapshot = await database.ref('todos').get();

    if (!snapshot.exists) {
      throw Exception("Invalid Request");
    }
    //Snapshot does exist
    return (snapshot.value as Map).values
        .map((e) => Map<String, dynamic>.from(e))
        .map((e) => Todo.fromMap(e))
        .toList();
  }

  @override
  Future<bool> add(Todo todo) async {
    // Manually ask Firebase to create a new 'slot' in the database first
    // This 'slot' is a DatabaseReference object which has a form of key-value pairs
    DatabaseReference reference = database.ref('todos').push();

    String id = reference.key!;
    // Get the key from the kay-value pair of DatabaseReference object created above

    Map<String, dynamic> data = {
      'id':
          id, // Use that key as the newly created Todo's id (which is a random looking string)
      'name': todo.name,
      'description': todo.description,
      'complete': todo.complete,
    };

    // Put the whole Todo object back into the database
    await reference.set(data);
    return true;
  }

  @override
  Future<bool> delete(Todo todo) async {
    // Get the exact slot we want to delete
    DatabaseReference ref = database.ref('todos/${todo.id}');

    await ref.remove();
    return true;
  }

  @override
  Future<bool> edit(Todo todo) async {
    // Get the exact slot for the todo we want to edit
    DatabaseReference ref = database.ref('todos/${todo.id}');

    // Pack the data exactly like we did in add()
    Map<String, dynamic> newData = {
      'id': todo.id,
      'name': todo.name,
      'description': todo.description,
      'complete': todo.complete,
    };

    // Overwrite the existing slot with the updated data
    await ref.set(newData);
    return true;
  }

  @override
  Future<Todo?> read(String id) async {
    // Get the specficic snapshot
    final DataSnapshot snapshot = await database.ref('todos/$id').get();

    if (snapshot.exists) {
      // Convert the value to a Map and build the Todo
      Map<String, dynamic> data = Map<String, dynamic>.from(
        snapshot.value as Map,
      );
      return Todo.fromMap(data);
    }
    return null;
  }
}
