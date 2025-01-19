class Report {
  final int id;
  final String title;
  final String author;
  final String description;
  final String pdfUrl;  // Add pdfUrl to store the PDF link or path

  Report({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.pdfUrl,
  });

  // Możesz dodać metodę do tworzenia instancji z mockowanych danych:
  factory Report.mock(int id, String title, String author, String description, String pdfUrl) {
    return Report(
      id: id,
      title: title,
      author: author,
      description: description,
      pdfUrl: pdfUrl
    );
  }
}
