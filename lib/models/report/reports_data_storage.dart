import 'dart:collection';
import 'dart:math';
import 'package:krit_app/config.dart';
import 'report.dart';

class ReportsDataStorage {
  static final ReportsDataStorage _singleton = ReportsDataStorage._internal();

  final List<Report> _reportList = [];
  List<Report> get reportList => UnmodifiableListView(_reportList);
  late Function _callback;

  factory ReportsDataStorage(Function callback) {
    _singleton._callback = callback;
    return _singleton;
  }

  final random = Random();

  String randomTitle() {
    return titles[random.nextInt(titles.length)];
  }

  String randomAuthor() {
    return authors[random.nextInt(authors.length)];
  }

  String randomDescription() {
    return descriptions[random.nextInt(descriptions.length)];
  }

  List<String> randomKeyWords() {
    if (keywords.length >= 2) {
      Set<int> indices = {};
      while (indices.length < 2) {
        indices.add(random.nextInt(keywords.length));
      }
      return indices.map((index) => keywords[index]).toList();
    } else {
      return keywords;
    }
  }

  int randomEventId() {//??????
    return random.nextInt(10) + 1; // Zakres od 1 do 10
  }

  final titles = [
    "Enhancing Software Testing of 5G Base Stations with LLM-driven Analysis",
    "Praktyczna realizacja ataków omijania systemów wykrywania włamań w sieciach",
    "Rozwój i zastosowanie systemu monitoringu urządzeń automatyki przemysłowej SMUAP",
    "Estymacja położenia i orientacji w systemie lokalizacyjnym z częściową synchronizacją węzłów referencyjnych",
    "Analiza kosztowa pasywnej optycznej sieci Xhaul z agregacją ruchu w warstwie optycznej",
    "Algorytmy sztucznej inteligencji w przetwarzaniu danych rozpoznania radioelektronicznego ELINT"
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

  final keywords = ["NLP", "LLM", "testowanie oprogramowania", "testy regresyjne"];

  ReportsDataStorage._internal() {
    if (Config.useMockData) {
      for (int i = 0; i < 15; i++) {
        _reportList.add(Report.mock(
          i,
          randomTitle(),
          randomAuthor(),
          randomDescription(),
          "C:\\Users\\hania\\Downloads\\Laboratory6.pdf",
          randomKeyWords(),
          randomEventId(),
        ));
      }
    }
  }

  List<Report> getReportsForEvent(int eventId) {
    return _reportList.where((report) => report.eventId == eventId).toList();
  }

  List<Report> filterReports(String query) {
    return _reportList.where((report) {
      return report.title.toLowerCase().contains(query.toLowerCase()) ||
          report.author.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
