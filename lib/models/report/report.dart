// import 'package:uuid/uuid.dart';
//
// class Report {
//   final String id;
//   final String title;
//   final String author;
//   final String description;
//   final String pdfUrl;
//   final List<String> keywords;
//   final String eventId;
//
//   Report({
//     required this.id,
//     required this.title,
//     required this.author,
//     required this.description,
//     required this.pdfUrl,
//     required this.keywords,
//     required this.eventId,
//   });
//
//   factory Report.mock(
//       String title,
//       String author,
//       String description,
//       String pdfUrl,
//       List<String> keywords,
//       String eventId) {
//     return Report(
//       id: Uuid().v4(),
//       title: title,
//       author: author,
//       description: description,
//       pdfUrl: pdfUrl,
//       keywords: keywords,
//       eventId: eventId,
//     );
//   }
//
//   factory Report.fromJson(Map<String, dynamic> json) {
//     return Report(
//       id: json['id'] ?? Uuid().v4(),
//       title: json['title'],
//       author: json['author'],
//       description: json['description'],
//       pdfUrl: json['pdfUrl'],
//       keywords: List<String>.from(json['keywords']),
//       eventId: json['eventId'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'author': author,
//       'description': description,
//       'pdfUrl': pdfUrl,
//       'keywords': keywords,
//       'eventId': eventId,
//     };
//   }
// }

import 'package:uuid/uuid.dart';

class Report {
  final String id;
  final String title;
  final String author;
  final String description;
  final String pdfUrl;
  final List<String> keywords;
  final String eventId;

  Report({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.pdfUrl,
    required this.keywords,
    required this.eventId,
  });

  factory Report.mock(
      String title,
      String author,
      String description,
      String pdfUrl,
      List<String> keywords,
      String eventId,
      ) {
    return Report(
      id: Uuid().v4(),
      title: title,
      author: author,
      description: description,
      pdfUrl: pdfUrl,
      keywords: keywords,
      eventId: eventId,
    );
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] ?? Uuid().v4(),
      title: json['title'] ?? 'Brak tytułu',
      author: json['author'] ?? 'Nieznany autor',
      description: json['description'] ?? 'Brak opisu',
      pdfUrl: json['pdfUrl'] ?? '',
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      eventId: json['eventId'] ?? 'brak_event_id',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'pdfUrl': pdfUrl,
      'keywords': keywords,
      'eventId': eventId,

    };
  }
}
