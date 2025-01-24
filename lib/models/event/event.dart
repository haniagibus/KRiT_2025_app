import '../report/report.dart';

class Event {
  final int id;
  String name;
  final String logoUrl;
  final String coverImageUrl;
  final String timeBegin;
  final String timeEnd;
  final DateTime date;
  final String description;
  final String room;
  final List<Report> reports;
  bool isFavourite;

  Event(
      this.id,
      this.name,
      this.logoUrl,
      this.coverImageUrl,
      this.timeBegin,
      this.timeEnd,
      this.date,
      this.description,
      this.room,
      this.reports,
      {this.isFavourite = false}
      );

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        logoUrl = json['logo'],
        coverImageUrl = json['cover'],
        timeBegin = json['begin'],
        timeEnd = json['end'],
        date = DateTime.parse(json['date']),
        description = json['description'],
        room = json['room'],
        isFavourite = json['isFavourite'] ?? false,
        reports = (json['reports'] as List<dynamic>)
            .map((reportJson) => Report.fromJson(reportJson))
            .toList();

  Map<String, dynamic> toJson() => {
    'name': name,
    'logo': logoUrl,
    'cover': coverImageUrl,
    'begin': timeBegin,
    'end': timeEnd,
    'date': date.toIso8601String(),
    'description': description,
    'room': room,
    'isFavourite': isFavourite,
    'reports': reports.map((report) => report.toJson()).toList(),
  };
}

class MockEvent extends Event {
  MockEvent(int id, String title, DateTime date, List<Report> reports)
      : super(
      id,
      title,
      "https://picsum.photos/500/500?$id",
      "https://picsum.photos/1000/300?$id",
      "10:00",
      "11:00",
      date,
      "mock event description",
      "NE 000", // Przykładowy numer pokoju
      reports // Przekazywanie listy raportów
  );
}
