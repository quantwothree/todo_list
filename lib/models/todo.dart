class Todo {
  final String name;
  final String description;
  bool complete;

  Todo({required this.name, required this.description, this.complete = false});
  // {} in constructors mean the properties are named properties

  @override
  String toString() {
    return "$name - ($description)"; // string interpolation
  }
}
