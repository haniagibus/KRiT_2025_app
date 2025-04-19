import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:krit_app/config.dart';
import 'package:krit_app/models/event/event.dart';
import 'report.dart';

class ReportsDataStorage extends ChangeNotifier {
  final List<Report> _reportList = [];
  final Random random = Random();

  UnmodifiableListView<Report> get reportList => UnmodifiableListView(_reportList);

  // Losowe dane
  final titles = [
    "Enhancing Software Testing of 5G Base Stations with LLM-driven Analysis",
    "Praktyczna realizacja ataków omijania systemów wykrywania włamań w sieciach",
    "Rozwój i zastosowanie systemu monitoringu urządzeń automatyki przemysłowej SMUAP",
    "Estymacja położenia i orientacji w systemie lokalizacyjnym z częściową synchronizacją węzłów referencyjnych",
    "Analiza kosztowa pasywnej optycznej sieci Xhaul z agregacją ruchu w warstwie optycznej",
    "Algorytmy sztucznej inteligencji w przetwarzaniu danych rozpoznania radioelektronicznego ELINT"
  ];

  final authors = [
    "Dr. John Smith", "Prof. Jane Doe", "Dr. Richard Roe", "Dr. Emily White", "Prof. Michael Brown"
  ];

  final descriptions = [
    "An in-depth exploration of machine learning algorithms.",
    "A beginner-friendly guide to building apps with Flutter.",
    "Exploring the applications of data science in various industries.",
    "The potential and future of artificial intelligence technologies.",
    "An introduction to the concepts and applications of quantum computing."
  ];

  final keywords = ["NLP", "LLM", "testowanie oprogramowania", "testy regresyjne"];

  // Generatory losowych danych
  String randomTitle() => titles[random.nextInt(titles.length)];
  String randomAuthor() => authors[random.nextInt(authors.length)];
  String randomDescription() => descriptions[random.nextInt(descriptions.length)];

  List<String> randomKeywords() {
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

  String randomEventId(List<Event> existingEvents) {
    if (existingEvents.isEmpty) {
      throw Exception("Brak eventów do przypisania raportów!");
    }
    return existingEvents[random.nextInt(existingEvents.length)].id;
  }

  void generateMockReports(List<Event> existingEvents) {
    if (Config.useMockData) {
      _reportList.clear();
      for (int i = 0; i < 15; i++) {
        String eventId = randomEventId(existingEvents);
        Report newReport = Report.mock(
          randomTitle(),
          randomAuthor(),
          randomDescription(),
          "/sdcard/Documents/organizacja_i_struktura_projektu_v1.0.pdf",
          randomKeywords(),
          eventId,
        );
        _reportList.add(newReport);

        // Dodanie do eventu
        Event? event = existingEvents.firstWhere((e) => e.id == eventId, orElse: () => null as Event);
        if (event != null) {
          event.reports.add(newReport);
        }
      }
      notifyListeners(); // 🔥 Ważne
    }
  }

  List<Report> getReportsForEvent(String eventId) {
    return _reportList.where((report) => report.eventId == eventId).toList();
  }

  List<Report> filterReports(String query) {
    return _reportList.where((report) {
      return report.title.toLowerCase().contains(query.toLowerCase()) ||
          report.author.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void addReport(Report report) {
    _reportList.add(report);
    notifyListeners();
  }

  void removeReport(Report report) {
    _reportList.remove(report);
    notifyListeners();
  }

  void clearReports() {
    _reportList.clear();
    notifyListeners();
  }
}
