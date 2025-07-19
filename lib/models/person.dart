
class Person {
  final int id;
  final String name;
  final String? birthYear;
  final String? hairColor;
  final String? gender;

  static const String keyName = 'name';
  static const String keyBirthday = 'birth_year';
  static const String keyGender = 'gender';
  static const String keyHairColor = 'hair_color';
  static const String keyUrl= 'url';

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
      name: json[Person.keyName],
      birthYear: json[Person.keyBirthday],
      hairColor: json[Person.keyHairColor],
      gender: json[Person.keyGender],
    );
  }
}