// import 'dart:collection';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:krit_app/config.dart';
// import '../ApiService.dart';
// import '../report/report.dart';
// import '../report/reports_data_storage.dart';
// import 'event.dart';
// import 'mocked_events.dart';
//
// class EventsDataStorage extends ChangeNotifier {
//   List<Event> _eventList = [];
//   bool _mockGenerated = false;
//   late ReportsDataStorage _reportsStorage;
//   VoidCallback? _callback;
//
//   List<Event> get eventList => UnmodifiableListView(_eventList);
//
//   List<Event> get favoriteEvents =>
//       _eventList.where((event) => event.isFavourite).toList();
//
//
//   //chwila stop backend
//   // static final EventsDataStorage _singleton = EventsDataStorage._internal();
//   // late Function _callback;
//   //
//   // /// Factory do singletona, umożliwiający rejestrację callbacku
//   // factory EventsDataStorage(Function callback) {
//   //   _singleton._callback = callback;
//   //   return _singleton;
//   // }
//   // EventsDataStorage._internal();
//
//   EventsDataStorage(this._reportsStorage, {VoidCallback? callback}) {
//   _callback = callback;
//   if (Config.useMockData && !_mockGenerated) {
//   _eventList = MockedEvents.getMockedEvents();
//   _reportsStorage.generateMockReports(_eventList);
//   _mockGenerated = true;
//   notifyListeners();
//   }
//   }
//
//
//   /// Ustawienie zewnętrznego storage raportów (dependency injection)
//   void updateReportsStorage(ReportsDataStorage newStorage) {
//     _reportsStorage = newStorage;
//
//     // Inicjalizacja mocków, jeśli wymagane
//     if (Config.useMockData && !_mockGenerated) {
//       _eventList = MockedEvents.getMockedEvents();
//       _reportsStorage.generateMockReports(_eventList);
//       _mockGenerated = true;
//       notifyListeners();
//     }
//   }
//
//   Future<void> initializeEvents() async {
//     print("🟡 Start pobierania eventów");
//
//     if (!Config.useMockData) {
//       _eventList = await ApiService().fetchEvents();
//       print("✅ Pobranie zakończone, liczba eventów: ${_eventList.length}");
//
//       for (var event in _eventList) {
//         print("📅 Event w storage: ${event.title} - ${event.dateTimeStart}");
//       }
//
//       _callback?.call();
//
//       //_callback!();
//       notifyListeners();
//     }
//   }
//
//   List<Event> filterEventsByQuery(String query) {
//     final lowerQuery = query.toLowerCase();
//     return eventList.where((event) {
//       final matchesEvent = event.title.toLowerCase().contains(lowerQuery) ||
//           event.subtitle.toLowerCase().contains(lowerQuery);
//
//       final matchingReports = _reportsStorage.filterReportsByQuery(query);
//       final matchesReport =
//       matchingReports.any((report) => event.reports.contains(report));
//
//       return matchesEvent || matchesReport;
//     }).toList();
//   }
//
//   void controlFavourite(Event event) {
//     final index = _eventList.indexOf(event);
//     if (index != -1) {
//       _eventList[index].isFavourite = !_eventList[index].isFavourite;
//       notifyListeners();
//     } else {
//       print("❌ Nie znaleziono wydarzenia w liście!");
//     }
//   }
//
//   List<Report> getReportsForEvent(String id) {
//     return _reportsStorage.getReportsForEvent(id);
//   }
//
//   List<Event> getEventsForDate(DateTime date) {
//     DateTime inputDateOnly = DateTime(date.year, date.month, date.day);
//     return _eventList.where((event) {
//       DateTime eventDateOnly = DateTime(
//           event.dateTimeStart.year, event.dateTimeStart.month, event.dateTimeStart.day);
//       return eventDateOnly.isAtSameMomentAs(inputDateOnly);
//     }).toList();
//   }
//
//   void addEvent(Event event) {
//     _eventList.add(event);
//     notifyListeners();
//   }
//
//   void updateEvent(Event oldEvent, Event updatedEvent) {
//     final index = _eventList.indexOf(oldEvent);
//     if (index != -1) {
//       _eventList[index] = updatedEvent;
//       notifyListeners();
//     }
//   }
//
//   void removeEvent(Event event) {
//     _eventList.remove(event);
//     notifyListeners();
//   }
//
//   void addReportToEvent(Report report) {
//     final event = _eventList.firstWhere(
//           (e) => e.id == report.eventId,
//       orElse: () => throw Exception('Event not found'),
//     );
//     event.reports.add(report);
//     notifyListeners();
//   }
//
//   void removeReportFromEvent(Report report) {
//     final event = _eventList.firstWhere(
//           (e) => e.id == report.eventId,
//       orElse: () => throw Exception('Event not found'),
//     );
//     event.reports.remove(report);
//     _reportsStorage.removeReport(report);
//     notifyListeners();
//   }
// }
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:krit_app/config.dart';
import '../ApiService.dart';
import '../report/report.dart';
import '../report/reports_data_storage.dart';
import 'event.dart';
import 'mocked_events.dart';

class EventsDataStorage extends ChangeNotifier {
  // Singleton implementation
  static final EventsDataStorage _instance = EventsDataStorage._internal();

  factory EventsDataStorage(ReportsDataStorage reportsStorage, {VoidCallback? callback}) {
    _instance._reportsStorage = reportsStorage;
    if (callback != null) {
      _instance._callback = callback;
    }
    return _instance;
  }

  EventsDataStorage._internal();

  // State variables
  List<Event> _eventList = [];
  bool _isInitialized = false;
  bool _mockGenerated = false;
  late ReportsDataStorage _reportsStorage;
  VoidCallback? _callback;

  // Getters
  List<Event> get eventList => UnmodifiableListView(_eventList);

  List<Event> get favoriteEvents =>
      _eventList.where((event) => event.isFavourite).toList();

  bool get isInitialized => _isInitialized;

  /// Update the reports storage reference
  void updateReportsStorage(ReportsDataStorage newStorage) {
    _reportsStorage = newStorage;

    // Initialize mocks if required, but only if not already done
    if (Config.useMockData && !_mockGenerated) {
      _generateMockData();
    }
  }

  /// Private method to generate mock data
  void _generateMockData() {
    if (Config.useMockData && !_mockGenerated) {
      print("🔄 Generating mock events data");
      _eventList = MockedEvents.getMockedEvents();
      _reportsStorage.generateMockReports(_eventList);
      _mockGenerated = true;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Initialize events (real or mock)
  Future<void> initializeEvents() async {
    // Skip if already initialized or if using mock data that's already generated
    if (_isInitialized || (Config.useMockData && _mockGenerated)) {
      print("🟢 Events already initialized, skipping initialization");
      return;
    }

    print("🟡 Start pobierania eventów");

    if (Config.useMockData) {
      _generateMockData();
    } else {
      try {
        final apiService = ApiService();
        _eventList = await apiService.fetchEvents();
        _isInitialized = true;

        print("✅ Pobranie zakończone, liczba eventów: ${_eventList.length}");

        for (var event in _eventList) {
          print("📅 Event w storage: ${event.title} - ${event.dateTimeStart}");
        }

        _callback?.call();
        notifyListeners();
      } catch (e) {
        print("❌ Błąd podczas inicjalizacji eventów: $e");
      }
    }
  }

  /// Refresh events from the backend
  Future<void> refreshEvents() async {
    print("🔄 Odświeżanie eventów");

    if (!Config.useMockData) {
      try {
        final apiService = ApiService();
        _eventList = await apiService.fetchEvents();
        _isInitialized = true;

        print("✅ Odświeżanie zakończone, liczba eventów: ${_eventList.length}");

        _callback?.call();
        notifyListeners();
      } catch (e) {
        print("❌ Błąd podczas odświeżania eventów: $e");
      }
    }
  }

  List<Event> filterEventsByQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return eventList.where((event) {
      final matchesEvent = event.title.toLowerCase().contains(lowerQuery) ||
          event.subtitle.toLowerCase().contains(lowerQuery);

      final matchingReports = _reportsStorage.filterReportsByQuery(query);
      final matchesReport =
      matchingReports.any((report) => event.reports.contains(report));

      return matchesEvent || matchesReport;
    }).toList();
  }

  void controlFavourite(Event event) {
    final index = _eventList.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _eventList[index].isFavourite = !_eventList[index].isFavourite;
      notifyListeners();
    } else {
      print("❌ Nie znaleziono wydarzenia w liście!");
    }
  }

  List<Report> getReportsForEvent(String id) {
    return _reportsStorage.getReportsForEvent(id);
  }

  List<Event> getEventsForDate(DateTime date) {
    DateTime inputDateOnly = DateTime(date.year, date.month, date.day);
    return _eventList.where((event) {
      DateTime eventDateOnly = DateTime(
          event.dateTimeStart.year, event.dateTimeStart.month, event.dateTimeStart.day);
      return eventDateOnly.isAtSameMomentAs(inputDateOnly);
    }).toList();
  }

  Future<void> addEvent(Event event) async {
    try {
      if (!Config.useMockData) {
        final apiService = ApiService();
        final addedEvent = await apiService.addEvent(event);

        // Check if event already exists to avoid duplicates
        if (!_eventList.any((e) => e.id == addedEvent.id)) {
          _eventList.add(addedEvent);
          print("✅ Event dodany do storage: ${addedEvent.title}");
        }
      } else {
        // For mock data, just add locally
        _eventList.add(event);
        print("✅ Mock event dodany do storage: ${event.title}");
      }

      notifyListeners();
    } catch (e) {
      print("❌ Błąd podczas dodawania eventu: $e");
      throw e;
    }
  }

  void updateEvent(Event oldEvent, Event updatedEvent) {
    final index = _eventList.indexWhere((e) => e.id == oldEvent.id);
    if (index != -1) {
      _eventList[index] = updatedEvent;
      notifyListeners();
    }
  }

  void removeEvent(Event event) {
    _eventList.removeWhere((e) => e.id == event.id);
    notifyListeners();
  }

  Future<void> addReportToEvent(Report report) async {
    try {
      // First add the report to the reports storage
      await _reportsStorage.addReport(report);

      // Then link it to the event
      final eventIndex = _eventList.indexWhere((e) => e.id == report.eventId);
      if (eventIndex != -1) {
        // Check if report is already linked to the event
        if (!_eventList[eventIndex].reports.any((r) => r.id == report.id)) {
          _eventList[eventIndex].reports.add(report);
          print("✅ Report linked to event: ${_eventList[eventIndex].title}");
          notifyListeners();
        }
      } else {
        print("❌ Event not found for report: ${report.title}");
        throw Exception('Event not found with ID: ${report.eventId}');
      }
    } catch (e) {
      print("❌ Error adding report to event: $e");
      throw e;
    }
  }

  void removeReportFromEvent(Report report) {
    final eventIndex = _eventList.indexWhere((e) => e.id == report.eventId);
    if (eventIndex != -1) {
      _eventList[eventIndex].reports.removeWhere((r) => r.id == report.id);
      _reportsStorage.removeReport(report);
      notifyListeners();
    } else {
      print("❌ Event not found for report removal: ${report.title}");
    }
  }
}