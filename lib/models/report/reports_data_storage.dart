import 'dart:collection';
import 'dart:math';
import 'package:krit_app/config.dart';
import 'report.dart';

class ReportsDataStorage {
  static final ReportsDataStorage _singleton = ReportsDataStorage._internal();

  List<Report> _reportList = [];
  List<Report> get reportList => UnmodifiableListView(_reportList); // Zapewnienie, że lista referatów jest tylko do odczytu
  late Function _callback;

  factory ReportsDataStorage(Function callback) {
    _singleton._callback = callback;
    return _singleton;
  }

  final random = Random(); // Do generowania losowych danych

  String randomTitle() {
    return titles[random.nextInt(titles.length)];
  }

  String randomAuthor() {
    return authors[random.nextInt(authors.length)];
  }

  String randomDescription() {
    return descriptions[random.nextInt(descriptions.length)];
  }

  final titles = [
    "Machine Learning: A Deep Dive",
    "Understanding Flutter",
    "Data Science and Its Applications",
    "The Future of AI",
    "Quantum Computing: The Next Frontier"
  ];

  final authors = [
    "Dr. John Smith",
    "Prof. Jane Doe",
    "Dr. Richard Roe",
    "Dr. Emily White",
    "Prof. Michael Brown"
  ];

  final descriptions = [
    "An in-depth exploration of machine learning algorithms.",
    "A beginner-friendly guide to building apps with Flutter.",
    "Exploring the applications of data science in various industries.",
    "The potential and future of artificial intelligence technologies.",
    "An introduction to the concepts and applications of quantum computing."
  ];

  ReportsDataStorage._internal() {
    if (Config.useMockData) {
      for (int i = 0; i < 5; i++) {
        _reportList.add(Report.mock(i, randomTitle(), randomAuthor(), randomDescription(), "C:\\Users\\hania\\Downloads\\Laboratory6.pdf"));
      }
    }
  }

  List<Report> filterReports(String query) {
    return _reportList.where((report) {
      return report.title.toLowerCase().contains(query.toLowerCase()) ||
          report.author.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
