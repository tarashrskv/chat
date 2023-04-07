import 'package:chat/models/gender.dart';

class Author {
  final Gender? gender;
  final int? age;
  final String? location;

  Author({this.gender, this.age, this.location});

  factory Author.fromJson(Map<String, dynamic> json) {

    return Author(
      gender: _getGender(json['gender']),
      age: json['age'],
      location: json['geo'],
    );
  }

  static Gender? _getGender(String? response) {
    switch (response) {
      case 'MALE': return Gender.male;
      case 'FEMALE': return Gender.female;
      default: return null;
    }
  }
}