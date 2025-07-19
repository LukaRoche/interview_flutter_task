class Person {
  final int id;
  final String name;
  final String? birthYear;
  final String? hairColor;
  final String? gender;

  Person({
    required this.id,
    required this.name,
    this.birthYear,
    this.hairColor,
    this.gender,
  });

  factory Person.fromJson(Map<String, dynamic> json, int id) {
    return Person(
      id: id,
      name: json['name'],
      birthYear: json['birth_year'],
      hairColor: json['hair_color'],
      gender: json['gender'],
    );
  }
}