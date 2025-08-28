import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:krit_app/config.dart';
import '../../services/api_service.dart';
import '../report/report.dart';
import '../report/reports_data_storage.dart';
import '../../services/favourite_event_service.dart';
import 'event.dart';
import 'mocked_events.dart';

class EventsDataStorage extends ChangeNotifier {
  static final EventsDataStorage _instance = EventsDataStorage._internal();

  factory EventsDataStorage(ReportsDataStorage reportsStorage, {VoidCallback? callback}) {
    _instance._reportsStorage = reportsStorage;
    if (callback != null) {
      _instance._callback = callback;
    }
    return _instance;
  }

  EventsDataStorage._internal();

  List<Event> _eventList = [];
  bool _isInitialized = false;
  bool _mockGenerated = false;
  late ReportsDataStorage _reportsStorage;
  VoidCallback? _callback;

  List<Event> get eventList => UnmodifiableListView(_eventList);

  List<Event> get favoriteEvents =>
      _eventList.where((event) => event.isFavourite).toList();

  bool get isInitialized => _isInitialized;

  void updateReportsStorage(ReportsDataStorage newStorage) {
    _reportsStorage = newStorage;

    if (Config.useMockData && !_mockGenerated) {
      _generateMockData();
    }
  }

  void _generateMockData() {
    if (Config.useMockData && !_mockGenerated) {
      print("Generating mock events data");
      _eventList = MockedEvents.getMockedEvents();
      _reportsStorage.generateMockReports(_eventList);
      _mockGenerated = true;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> initializeEvents(FavoritesService favoritesService) async {
    // Skip if already initialized or if using mock data that's already generated
    if (_isInitialized || (Config.useMockData && _mockGenerated)) {
      print("Events already initialized, skipping initialization");
      return;
    }

    print("Start pobierania eventów");

    if (Config.useMockData) {
      _generateMockData();
    } else {
      try {
        final apiService = ApiService();
        _eventList = await apiService.fetchEvents(favoritesService);
        _isInitialized = true;

        print("Pobranie zakończone, liczba eventów: ${_eventList.length}");

        for (var event in _eventList) {
          print("Event w storage: ${event.title} - ${event.dateTimeStart}");
        }

        _callback?.call();
        notifyListeners();
      } catch (e) {
        print("Błąd podczas inicjalizacji eventów: $e");
      }
    }
  }

  /// Refresh events from the backend
  Future<void> refreshEvents(FavoritesService favoritesService) async {
    print("Odświeżanie eventów");

    if (!Config.useMockData) {
      try {
        final apiService = ApiService();
        _eventList = await apiService.fetchEvents(favoritesService);
        // _isInitialized = true;

        print("Odświeżanie zakończone, liczba eventów: ${_eventList.length}");

        for (Event event in _eventList) {
          print("isFavorite ${event.isFavourite}");
        }

        _callback?.call();
        notifyListeners();
      } catch (e) {
        print("Błąd podczas odświeżania eventów: $e");
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

  Future<void> controlFavourite(Event event) async {
    final index = _eventList.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      final updatedEvent = Event(
        id: event.id,
        title: event.title,
        subtitle: event.subtitle,
        type: event.type,
        dateTimeStart: event.dateTimeStart,
        dateTimeEnd: event.dateTimeEnd,
        building: event.building,
        room: event.room,
        reports: event.reports,
        isFavourite: event.isFavourite,
      );

      try {
        await updateEvent(event, updatedEvent);
      } catch (e) {
        print("[!] ERROR when updating isFavourite: $e");
      }
    } else {
      print("[!] ERROR event not found in _evenList");
    }
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
          print("Event added to storage: ${addedEvent.title}");
        }
      } else {
        // For mock data, just add locally
        _eventList.add(event);
        print("Mock event added to storage: ${event.title}");
      }

      notifyListeners();
    } catch (e, stackTrace) {
      print("Error adding eventu: $e");
      print("Stack Trace: $stackTrace");
      throw e;
    }
  }

  Future<void> updateEvent(Event oldEvent, Event updatedEvent) async {
    try {
      final index = _eventList.indexWhere((e) => e.id == oldEvent.id);
      if (index != -1) {
        if (!Config.useMockData) {
          // Call the API service to update the event on the backend
          final apiService = ApiService();

          // Make sure the updated event has the same ID as the old one
          final eventToUpdate = Event(
            id: oldEvent.id,  // Preserve the original ID
            title: updatedEvent.title,
            subtitle: updatedEvent.subtitle,
            //description: updatedEvent.description,
            type: updatedEvent.type,
            dateTimeStart: updatedEvent.dateTimeStart,
            dateTimeEnd: updatedEvent.dateTimeEnd,
            building: updatedEvent.building,
            room: updatedEvent.room,
            reports: updatedEvent.reports,
            isFavourite: updatedEvent.isFavourite,
          );

          // Send the update to the backend
          final updatedEventFromApi = await apiService.updateEvent(eventToUpdate);

          // Update the local copy with the response from the API
          _eventList[index] = updatedEventFromApi;
          print("Event updated successfully: ${updatedEventFromApi.title}");
        } else {
          // For mock data, just update locally
          _eventList[index] = updatedEvent;
          print("Mock event updated in storage: ${updatedEvent.title}");
        }

        notifyListeners();
      } else {
        print("Event not found for update: ${oldEvent.title}");
        throw Exception('Event not found with ID: ${oldEvent.id}');
      }
    } catch (e, stackTrace) {
      print("Error updating event: $e");
      print("Stack Trace: $stackTrace");
      throw e;
    }
  }

  Future<void> removeEvent(Event event) async {
    final apiService = ApiService();
    await apiService.deleteEvent(event);
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
          print("Report linked to event: ${_eventList[eventIndex].title}");
          notifyListeners();
        }
      } else {
        print("Event not found for report: ${report.title}");
        throw Exception('Event not found with ID: ${report.eventId}');
      }
    } catch (e) {
      print("Error adding report to event: $e");
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
      print("Event not found for report removal: ${report.title}");
    }

  }

  Event? getEventById(String id) {
    try {
      return _eventList.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }
}