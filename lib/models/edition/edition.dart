import 'package:uuid/uuid.dart';

class Edition {
  final String id;
  final String title;
  final String description;
  final DateTime dateTimeStart;
  final DateTime dateTimeEnd;

  Edition({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTimeStart,
    required this.dateTimeEnd,
  });

  factory Edition.mock({
    required String title,
    required String description,
    required DateTime dateTimeStart,
    required DateTime dateTimeEnd,
  }) {
    return Edition(
      id: Uuid().v4(),
      title: title,
      description: description,
      dateTimeStart: dateTimeStart,
      dateTimeEnd: dateTimeEnd,
    );
  }

  factory Edition.fromJson(Map<String, dynamic> json) {
    return Edition(
      id: json['id'] ?? Uuid().v4(),
      title: json['title'],
      description: json['description'],
      dateTimeStart: DateTime.parse(json['dateTimeStart']),
      dateTimeEnd: DateTime.parse(json['dateTimeEnd']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTimeStart': dateTimeStart.toIso8601String(),
      'dateTimeEnd': dateTimeEnd.toIso8601String(),
    };
  }
}
