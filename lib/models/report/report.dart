import 'package:uuid/uuid.dart';
import 'dart:typed_data';

class Report {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String pdfUrl;
  final List<String> keywords;
  final String eventId;
  final Uint8List? pdfBytes;

  Report({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.pdfUrl,
    required this.keywords,
    required this.eventId,
    required this.pdfBytes
  });

  factory Report.mock(
      String title,
      List<String> authors,
      String description,
      String pdfUrl,
      List<String> keywords,
      String eventId,
      Uint8List? pdfBytes
      ) {
    return Report(
      id: Uuid().v4(),
      title: title,
      authors: authors,
      description: description,
      pdfUrl: pdfUrl,
      keywords: keywords,
      eventId: eventId,
        pdfBytes: pdfBytes
    );
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] ?? Uuid().v4(),
      title: json['title'] ?? 'Brak tytułu',
      authors: (json['authors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? ['Nieznany autor'],
      description: json['description'] ?? 'Brak opisu',
      pdfUrl: json['pdfUrl'] ?? '',
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      eventId: json['eventId'] ?? 'brak_event_id',
      pdfBytes: null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'pdfUrl': pdfUrl,
      'keywords': keywords,
    };
  }
}
