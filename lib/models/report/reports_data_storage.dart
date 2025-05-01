// import 'dart:collection';
// import 'dart:math';
// import 'package:krit_app/config.dart';
// import 'package:krit_app/models/event/event.dart';
// import '../ApiService.dart';
// import 'report.dart';
//
// class ReportsDataStorage {
//   static final ReportsDataStorage _singleton = ReportsDataStorage._internal();
//
//    List<Report> _reportList = [];
//   List<Report> get reportList => UnmodifiableListView(_reportList);
//   late Function _callback;
//   final Random random = Random();
//
//   factory ReportsDataStorage(Function callback) {
//     _singleton._callback = callback;
//     return _singleton;
//   }
//
//   String randomTitle() => titles[random.nextInt(titles.length)];
//   String randomAuthor() => authors[random.nextInt(authors.length)];
//   String randomDescription() => descriptions[random.nextInt(descriptions.length)];
//
//   List<String> randomKeywords() {
//     if (keywords.length >= 2) {
//       Set<int> indices = {};
//       while (indices.length < 2) {
//         indices.add(random.nextInt(keywords.length));
//       }
//       return indices.map((index) => keywords[index]).toList();
//     } else {
//       return keywords;
//     }
//   }
//
//   String randomEventId(List<Event> existingEvents) {
//     if (existingEvents.isEmpty) {
//       throw Exception("Brak eventów do przypisania raportów!");
//     }
//     return existingEvents[random.nextInt(existingEvents.length)].id;
//   }
//
//   final titles = [
//     "Enhancing Software Testing of 5G Base Stations with LLM-driven Analysis",
//     "Praktyczna realizacja ataków omijania systemów wykrywania włamań w sieciach",
//     "Rozwój i zastosowanie systemu monitoringu urządzeń automatyki przemysłowej SMUAP",
//     "Estymacja położenia i orientacji w systemie lokalizacyjnym z częściową synchronizacją węzłów referencyjnych",
//     "Analiza kosztowa pasywnej optycznej sieci Xhaul z agregacją ruchu w warstwie optycznej",
//     "Algorytmy sztucznej inteligencji w przetwarzaniu danych rozpoznania radioelektronicznego ELINT"
//   ];
//
//   final authors = ["Dr. John Smith", "Prof. Jane Doe", "Dr. Richard Roe", "Dr. Emily White", "Prof. Michael Brown"];
//
//   final descriptions = [
//     "An in-depth exploration of machine learning algorithms.",
//     "A beginner-friendly guide to building apps with Flutter.",
//     "Exploring the applications of data science in various industries.",
//     "The potential and future of artificial intelligence technologies.",
//     "An introduction to the concepts and applications of quantum computing."
//   ];
//
//   final keywords = ["NLP", "LLM", "testowanie oprogramowania", "testy regresyjne"];
//
//   ReportsDataStorage._internal();
//   Future<void> initializeReports() async {
//     print("🟡 Start pobierania raportów");
//
//     // if (!Config.useMockData) {  // Upewnij się, że nie korzystasz z mockowanych danych
//     _reportList = await ApiService().fetchReports();
//     print("✅ Pobranie zakończone, liczba raportów: ${_reportList.length}");
//
//     for (var event in _reportList) {
//       print("📅 Event w storage: ${event.title} - ${event.id}");
//     }
//
//     _callback();
//     //}
//   }
//   //
//   // void generateMockReports(List<Event> existingEvents) {
//   //   if (Config.useMockData) {
//   //     _reportList.clear();
//   //     for (int i = 0; i < 15; i++) {
//   //       String eventId = randomEventId(existingEvents);
//   //       Report newReport = Report.mock(
//   //         randomTitle(),
//   //         randomAuthor(),
//   //         randomDescription(),
//   //         "/sdcard/Documents/organizacja_i_struktura_projektu_v1.0 (2).pdf",
//   //         randomKeywords(),
//   //         eventId,
//   //       );
//   //
//   //       _reportList.add(newReport);
//   //
//   //       Event? event = existingEvents.firstWhere((e) => e.id == eventId, orElse: () => null as Event);
//   //       if (event != null) {
//   //         event.reports.add(newReport);
//   //       }
//   //     }
//   //   }
//   // }
//
//   List<Report> getReportsForEvent(String eventId) {
//     return _reportList.where((report) => report.eventId == eventId).toList();
//   }
//
//   List<Report> filterReports(String query) {
//     return _reportList.where((report) {
//       return report.title.toLowerCase().contains(query.toLowerCase()) ||
//           report.author.toLowerCase().contains(query.toLowerCase());
//     }).toList();
//   }
// }
import 'dart:collection';
import 'dart:math';
import 'package:krit_app/models/event/event.dart';
import '../ApiService.dart';
import 'report.dart';

class ReportsDataStorage {
  static final ReportsDataStorage _singleton = ReportsDataStorage._internal();

  List<Report> _reportList = [];
  List<Report> get reportList => UnmodifiableListView(_reportList);
  late Function _callback;
  final Random random = Random();

  factory ReportsDataStorage(Function callback) {
    _singleton._callback = callback;
    return _singleton;
  }

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

  final titles = [
    "Enhancing Software Testing of 5G Base Stations with LLM-driven Analysis",
    "Praktyczna realizacja ataków omijania systemów wykrywania włamań w sieciach",
    "Rozwój i zastosowanie systemu monitoringu urządzeń automatyki przemysłowej SMUAP",
    "Estymacja położenia i orientacji w systemie lokalizacyjnym z częściową synchronizacją węzłów referencyjnych",
    "Analiza kosztowa pasywnej optycznej sieci Xhaul z agregacją ruchu w warstwie optycznej",
    "Algorytmy sztucznej inteligencji w przetwarzaniu danych rozpoznania radioelektronicznego ELINT"
  ];

  final authors = ["Dr. John Smith", "Prof. Jane Doe", "Dr. Richard Roe", "Dr. Emily White", "Prof. Michael Brown"];

  final descriptions = [
    "An in-depth exploration of machine learning algorithms.",
    "A beginner-friendly guide to building apps with Flutter.",
    "Exploring the applications of data science in various industries.",
    "The potential and future of artificial intelligence technologies.",
    "An introduction to the concepts and applications of quantum computing."
  ];

  final keywords = ["NLP", "LLM", "testowanie oprogramowania", "testy regresyjne"];

  ReportsDataStorage._internal();

  Future<void> initializeReports() async {
    print("🟡 Start pobierania raportów");

    try {
      _reportList = await ApiService().fetchReports();
      print("✅ Pobranie zakończone, liczba raportów: ${_reportList.length}");

      for (var report in _reportList) {
        print("📄 Raport w storage: ${report.title} - ${report.id}");
      }

      _callback();
    } catch (e) {
      print("❌ Błąd podczas inicjalizacji raportów: $e");
    }
  }

  // Add method to refresh reports
  Future<void> refreshReports() async {
    print("🔄 Odświeżanie raportów");

    try {
      _reportList = await ApiService().fetchReports();
      print("✅ Odświeżanie zakończone, liczba raportów: ${_reportList.length}");

      _callback();
    } catch (e) {
      print("❌ Błąd podczas odświeżania raportów: $e");
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
}