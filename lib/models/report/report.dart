class Report {
  final int id;
  final String title;
  final String author;
  final String description;
  final String pdfUrl;

  Report({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.pdfUrl,
  });

  factory Report.mock(
      int id, String title, String author, String description, String pdfUrl) {
    return Report(
      id: id,
      title: title,
      author: author,
      description: description,
      pdfUrl: pdfUrl,
    );
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      pdfUrl: json['pdfUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'pdfUrl': pdfUrl,
    };
  }
}
