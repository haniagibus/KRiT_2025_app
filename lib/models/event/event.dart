import 'package:intl/intl.dart';
import 'package:krit_app/models/event/event_type.dart';
import 'package:krit_app/models/report/report.dart';

class Event {
  String name;
  EventType type;
  final DateTime dateTimeStart;
  final DateTime dateTimeEnd;
  final String formattedDate;
  final String formattedTime;
  final String description;
  final String building;
  final String room;
  List<Report> reports;
  bool isFavourite;


  Event(
      this.name,
      this.type,
      this.dateTimeStart,
      this.dateTimeEnd,
      this.formattedDate,
      this.formattedTime,
      this.description,
      this.building,
      this.room,
      this.reports,
          {this.isFavourite = false}
      );

  Event.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        type = EventType.values.firstWhere(
                (e) => e.toString() == 'EventType.${json['type']}'),
        dateTimeStart = DateTime.parse(json['dateTimeStart']),
        dateTimeEnd = DateTime.parse(json['dateTimeStart']),
        formattedDate = json['formattedDate'],
        formattedTime = json['formattedTime'],
        description = json['description'],
        building = json['building'],
        room = json['room'],
        reports = json['reports'],
        isFavourite = json['isFavourite'] ?? false;


  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.toString().split('.').last,
    'dateTimeStart': dateTimeStart.toIso8601String(),
    'dateTimeEnd': dateTimeEnd.toIso8601String(),
    'formattedDate': formattedDate,
    'formattedTime': formattedTime,
    'description': description,
    'building': building,
    'room': room,
    'reports': reports,
    'isFavourite': isFavourite,
  };
}

class MockEvent extends Event {
  MockEvent(int id, String title, EventType type, DateTime dateStart, DateTime dateEnd,
      String description, String building, String room, List<Report> reports)
      : super(
    title,
    type,
    dateStart,
    dateEnd,
    DateFormat('d MMM', 'pl_PL').format(dateStart),
    "${DateFormat('HH:mm', 'pl_PL').format(dateStart)} - ${DateFormat('HH:mm', 'pl_PL').format(dateEnd)}",
    description,
    building,
    room,
    reports,
  );
}
