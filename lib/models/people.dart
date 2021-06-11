class Person {
  String? character;
  String? name;

  Person({this.character, this.name});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      character: json['character'],
      name: json['name'],
    );
  }
}
