class Todo {
  final String name;
  final String description;
  bool complete;
  final String? id;

  Todo({
    required this.name,
    required this.description,
    this.complete = false,
    this.id,
  });
  // {} in constructors mean the properties are named properties

  @override
  String toString() {
    return "$name - ($description)"; // string interpolation
  }

  // Map<String, dynamic> means toMap() returns an object of type Map
  // Which is a dictionary with key-value pairs
  // Specifically the key's type is String and the value's type can be dynamic

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'complete': complete,
    };
  }

  // This is a named factory constructor, hence Todo.fromMap(), fromMap is the name of this constructor
  // The keyword factory allows the constructor to have logic done before creating the instance
  // The logic lives in {}
  // In this case we are preparing the raw data from SQLite to the right format for a Todo object

  factory Todo.fromMap(Map<String, dynamic> map) {
    // Checks if complete is True/False, if yes assign True/False to it
    // If not True/False then assign null to it

    bool? complete = map['complete'] is bool ? map['complete'] : null;

    // ??= checks if complete is Null, if yes NULL then ignores the logic after ??=
    // If not NULL then proceed to the logic afer ??=
    // Which assigns 1 if True otherwise False
    // Because SQLite stores 1 and 0 for Booleans

    complete ??= map['complete'] == 1 ? true : false;

    return Todo(
      id: map['id'].toString(),
      name: map['name'],
      description: map['description'],
      complete: complete,
    );
  }
}
