import 'package:intl/intl.dart';
import 'package:krit_app/models/event/event_type.dart';
import 'package:krit_app/models/report/report.dart';
import 'package:uuid/uuid.dart';

class Event {
  final String id;
  final String title;
  final String subtitle;
  final EventType type;
  final DateTime dateTimeStart;
  final DateTime dateTimeEnd;
  final String description;
  final String building;
  final String room;
  final List<Report> reports;
  bool isFavourite;

  String get formattedDate => DateFormat('d MMM', 'pl_PL').format(dateTimeStart);
  String get formattedTime =>
      "${DateFormat('HH:mm', 'pl_PL').format(dateTimeStart)} - ${DateFormat('HH:mm', 'pl_PL').format(dateTimeEnd)}";

  Event({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.description,
    required this.building,
    required this.room,
    required this.reports,
    this.isFavourite = false
  }) : id = Uuid().v4();

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      subtitle: json['subtitle'],
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
      isFavourite: json['isFavourite'] ?? false
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'type': type.toString().split('.').last,
    'dateTimeStart': dateTimeStart.toIso8601String(),
    'dateTimeEnd': dateTimeEnd.toIso8601String(),
    'description': description,
    'building': building,
    'room': "Sala $room",
    'reports': reports.map((report) => report.toJson()).toList(),
    'isFavourite': isFavourite,
  };
}
