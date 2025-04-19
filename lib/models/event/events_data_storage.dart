import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:krit_app/config.dart';
import '../report/report.dart';
import '../report/reports_data_storage.dart';
import 'event.dart';
import 'mocked_events.dart';

class EventsDataStorage extends ChangeNotifier {
  ReportsDataStorage _reportsStorage;
  List<Event> _eventList = [];
  List<Event> get eventList => UnmodifiableListView(_eventList);

  EventsDataStorage(this._reportsStorage) {
    if (Config.useMockData) {
      _eventList.addAll(MockedEvents.getMockedEvents());
      _reportsStorage.generateMockReports(_eventList);
    }
  }

  List<Event> get favoriteEvents =>
      _eventList.where((event) => event.isFavourite).toList();

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

}
