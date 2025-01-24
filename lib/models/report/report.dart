class Report {
  final int id;
  final String title;
  final String author;
  final String description;
  final String pdfUrl;
  final List<String> keywords;
  final int eventId;

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
      int id,
      String title,
      String author,
      String description,
      String pdfUrl,
      List<String> keywords,
      int eventId,
      ) {
    return Report(
      id: id,
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
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      pdfUrl: json['pdfUrl'],
      keywords: List<String>.from(json['keywords']),
      eventId: json['eventId'],
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
