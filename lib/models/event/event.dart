import 'package:intl/intl.dart';
import 'package:krit_app/models/event/event_type.dart';
import 'package:krit_app/models/report/report.dart';

class Event {
  final int id;
  final String name;
  final EventType type;
  final DateTime dateTimeStart;
  final DateTime dateTimeEnd;
  final String description;
  final String building;
  final String room;
  final List<Report> reports;
  bool isFavourite;

  // Computed properties for formatted date and time
  String get formattedDate => DateFormat('d MMM', 'pl_PL').format(dateTimeStart);
  String get formattedTime =>
      "${DateFormat('HH:mm', 'pl_PL').format(dateTimeStart)} - ${DateFormat('HH:mm', 'pl_PL').format(dateTimeEnd)}";

  Event({
    required this.id,
    required this.name,
    required this.type,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.description,
    required this.building,
    required this.room,
    required this.reports,
    this.isFavourite = false,
  });

  // Add fromJson for deserialization
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      type: EventType.values.firstWhere(
              (e) => e.toString() == 'EventType.${json['type']}'),
      dateTimeStart: DateTime.parse(json['dateTimeStart']),
      dateTimeEnd: DateTime.parse(json['dateTimeEnd']),
      description: json['description'],
      building: json['building'],
      room: json['room'],
      reports: (json['reports'] as List<dynamic>)
          .map((reportJson) => Report.fromJson(reportJson))
          .toList(),
      isFavourite: json['isFavourite'] ?? false,
    );
  }

  // Add toJson for serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.toString().split('.').last,
    'dateTimeStart': dateTimeStart.toIso8601String(),
    'dateTimeEnd': dateTimeEnd.toIso8601String(),
    'description': description,
    'building': building,
    'room': room,
    'reports': reports.map((report) => report.toJson()).toList(),
    'isFavourite': isFavourite,
  };
}
