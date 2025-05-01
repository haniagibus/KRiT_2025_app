import 'dart:collection';
//BACKEND
// import 'package:krit_app/models/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:krit_app/config.dart';
import 'package:flutter/scheduler.dart';
import '../report/report.dart';
import '../report/reports_data_storage.dart';
import 'event.dart';
import 'mocked_events.dart';

class EventsDataStorage extends ChangeNotifier {
  ReportsDataStorage _reportsStorage;
  List<Event> _eventList = [];
  List<Event> get eventList => UnmodifiableListView(_eventList);
  bool _mockGenerated = false;

  EventsDataStorage(this._reportsStorage) {
    if (Config.useMockData) {
      _eventList.addAll(MockedEvents.getMockedEvents());
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_mockGenerated) {
          _reportsStorage.generateMockReports(_eventList);
          _mockGenerated = true;
        }
      });
    }
  }

  List<Event> get favoriteEvents =>
      _eventList.where((event) => event.isFavourite).toList();

//BACKEND
//   factory EventsDataStorage(Function callback) {
//     _singleton._callback = callback;
//     return _singleton;
//   }

//   // EventsDataStorage._internal() {
//   //   if (Config.useMockData) {
//   //     _eventList = MockedEvents.getMockedEvents();
//   //     // Tworzymy raporty dla eventów
//   //     _reportsStorage.generateMockReports(_eventList);
//   //   }
//   // }



//   EventsDataStorage._internal();
//   //asynchronicznie pobieranie danych
//   Future<void> initializeEvents() async {
//     print("🟡 Start pobierania eventów");

//    // if (!Config.useMockData) {  // Upewnij się, że nie korzystasz z mockowanych danych
//       _eventList = await ApiService().fetchEvents();
//       print("✅ Pobranie zakończone, liczba eventów: ${_eventList.length}");

//       for (var event in _eventList) {
//         print("📅 Event w storage: ${event.title} - ${event.dateTimeStart}");
//       }

//       _callback();
//     //}
//   }



//   List<Event> filterEvents(String query) {
//     return _eventList.where((event) {
//       bool matchesName = event.title.toLowerCase().contains(query.toLowerCase());
//       bool matchesDescription = event.description.toLowerCase().contains(query.toLowerCase());
//       bool matchesType = event.type.toString().toLowerCase().contains(query.toLowerCase());
//       return matchesName || matchesDescription || matchesType;
  List<Event> filterEventsByQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return eventList.where((event) {
      final matchesEvent = event.title.toLowerCase().contains(lowerQuery) ||
          event.subtitle.toLowerCase().contains(lowerQuery);

      final matchingReports = _reportsStorage.filterReportsByQuery(query);
      final matchesReport = matchingReports.any((report) => event.reports.contains(report));

      return matchesEvent || matchesReport;
    }).toList();
  }


  void controlFavourite(Event event) {
    final index = _eventList.indexOf(event);
    if (index != -1) {
      _eventList[index].isFavourite = !_eventList[index].isFavourite;
      notifyListeners();
    } else {
      print("Nie znaleziono wydarzenia w liście!");
    }
  }

  List<Report> getReportsForEvent(String id) {
    return _reportsStorage.getReportsForEvent(id);
  }

  List<Event> getEventsForDate(DateTime date) {
    return _eventList.where((event) {
      DateTime eventDateOnly = DateTime(
          event.dateTimeStart.year, event.dateTimeStart.month, event.dateTimeStart.day);
      DateTime inputDateOnly = DateTime(date.year, date.month, date.day);
      return eventDateOnly.isAtSameMomentAs(inputDateOnly);
    }).toList();
  }

  void addEvent(Event event) {
    _eventList.add(event);
    notifyListeners();
  }

  void updateEvent(Event oldEvent, Event updatedEvent) {
    final index = _eventList.indexOf(oldEvent);
    if (index != -1) {
      _eventList[index] = updatedEvent;
      notifyListeners();
    }
  }

  void removeEvent(Event event) {
    _eventList.remove(event);
    notifyListeners();
  }


  void addReportToEvent(Report report) {
    final event = _eventList.firstWhere((e) => e.id == report.eventId, orElse: () => throw Exception('Event not found'));
    event.reports.add(report);
    notifyListeners();
  }

  void removeReportFromEvent(Report report){
    final event = _eventList.firstWhere((e) => e.id == report.eventId, orElse: () => throw Exception('Event not found'));
    event.reports.remove(report);
    _reportsStorage.removeReport(report);
    notifyListeners();
  }

  void updateReportsStorage(ReportsDataStorage newStorage) {
    _reportsStorage = newStorage;
  }

}
