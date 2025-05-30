import 'dart:collection';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:krit_app/config.dart';
import 'package:krit_app/models/event/event.dart';
import '../../services/api_service.dart';
import 'report.dart';

class ReportsDataStorage extends ChangeNotifier {
  static final ReportsDataStorage _instance = ReportsDataStorage._internal();

  factory ReportsDataStorage({Function? callback}) {
    if (callback != null) {
      _instance._callback = callback;
    }
    return _instance;
  }

  ReportsDataStorage._internal();

  List<Report> _reportList = [];
  bool _isInitialized = false;
  Function? _callback;
  final Random random = Random();

  List<Report> get reportList => UnmodifiableListView(_reportList);
  bool get isInitialized => _isInitialized;

  // Mock data generation helpers
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

  String randomTitle() => titles[random.nextInt(titles.length)];
  String randomDescription() => descriptions[random.nextInt(descriptions.length)];

  List<String> randomAuthors() {
    if (authors.length >= 2) {
      Set<int> indices = {};
      while (indices.length < 2) {
        indices.add(random.nextInt(authors.length));
      }
      return indices.map((index) => authors[index]).toList();
    } else {
      return authors;
    }
  }

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

  String? randomEventId(List<Event> existingEvents) {
    if (existingEvents.isEmpty) {
      throw Exception("No existing events to add reports to!");
    }
    return existingEvents[random.nextInt(existingEvents.length)].id;
  }

  // Initialize reports only if not already initialized
  Future<void> initializeReports() async {
    if (_isInitialized && !Config.useMockData) {
      print("🟢 Reports already initialized, skipping initialization");
      return;
    }

    print("🟡 Starting report initialization");

    try {
      final apiService = ApiService();

      if (!Config.useMockData) {
        _reportList = await apiService.fetchReports();
        _isInitialized = true;
        print("✅ Pobranie zakończone, liczba raportów: ${_reportList.length}");

        for (var report in _reportList) {
          print("Raport w storage: ${report.title} - ${report.id}");
        }
      }

      // Only call callback if it's defined
      if (_callback != null) {
        _callback!();
      }
      notifyListeners();
    } catch (e) {
      print("❌ Błąd podczas inicjalizacji raportów: $e");
    }
  }

  Future<void> refreshReports() async {
    print("🔄 Odświeżanie raportów");

    try {
      final apiService = ApiService();
      _reportList = await apiService.fetchReports();
      _isInitialized = true;
      print("✅ Odświeżanie zakończone, liczba raportów: ${_reportList.length}");

      // Only call callback if it's defined
      if (_callback != null) {
        _callback!();
      }
      notifyListeners();
    } catch (e) {
      print("❌ Błąd podczas odświeżania raportów: $e");
    }
  }

  void generateMockReports(List<Event> existingEvents) {
    // if (Config.useMockData && !_isInitialized) {
    //   _reportList.clear();
    //   for (int i = 0; i < 15; i++) {
    //     String? eventId = randomEventId(existingEvents);
    //     Report newReport = Report.mock(
    //       randomTitle(),
    //       randomAuthors(),
    //       randomDescription(),
    //       "/sdcard/Documents/organizacja_i_struktura_projektu_v1.0.pdf",
    //       randomKeywords(),
    //       eventId!,
    //     );
    //     _reportList.add(newReport);
    //
    //     // Find the event and add report to it
    //     try {
    //       Event event = existingEvents.firstWhere((e) => e.id == eventId);
    //       if (!event.reports.contains(newReport)) {
    //         event.reports.add(newReport);
    //       }
    //     } catch (e) {
    //       print("❌ Event not found for ID: $eventId");
    //     }
    //   }
    //   _isInitialized = true;
    //   notifyListeners();
    // }
  }

  List<Report> getReportsForEvent(String eventId) {
    return _reportList.where((report) => report.eventId == eventId).toList();
  }

  List<Report> filterReportsByQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return reportList.where((report) {
      return report.title.toLowerCase().contains(lowerQuery) ||
          report.authors.any((author) => author.toLowerCase().contains(lowerQuery))||
          report.keywords.any((keyword) => keyword.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  Future<void> addReport(Report report) async {
    try {
      final apiService = ApiService();
      final addedReport = await apiService.addReport(report);

      if (!_reportList.any((r) => r.id == addedReport.id)) {
        _reportList.add(addedReport);
        print("✅ Raport dodany do storage: ${addedReport.title}");
        notifyListeners();
      }
    } catch (e) {
      print("❌ Błąd podczas dodawania raportu: $e");
      throw e;
    }
  }

  Future<void> updateReport(Report oldReport, Report updatedReport) async {
    final index = _reportList.indexWhere((r) => r.id == oldReport.id);
    if (index != -1) {
      final apiService = ApiService();
      await apiService.updateReport(updatedReport);
      notifyListeners();
    }
  }

  Future<void> removeReport(Report report) async {
    _reportList.removeWhere((r) => r.id == report.id);
    final apiService = ApiService();
    await apiService.deleteReport(report);
    notifyListeners();
  }
}