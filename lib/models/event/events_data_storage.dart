import 'dart:collection';
import 'package:krit_app/config.dart';
import 'event.dart';
import 'mocked_events.dart';

class EventsDataStorage {
  static final EventsDataStorage _singleton = EventsDataStorage._internal();

  List<Event> _eventList = [];
  List<Event> get eventList => UnmodifiableListView(_eventList);
  late Function _callback;

  List<Event> get favoriteEvents =>
      _eventList.where((event) => event.isFavourite).toList();

  factory EventsDataStorage(Function callback) {
    _singleton._callback = callback;
    return _singleton;
  }


  EventsDataStorage._internal() {
    if (Config.useMockData) {
      // Add mocked events
      _eventList = MockedEvents.getMockedEvents();
    }
  }

  // Similar to the ReportsDataStorage's filtering, implement a filtering method
  List<Event> filterEvents(String query) {
    return _eventList.where((event) {
      // Check if the event name or description matches the query (case-insensitive)
      bool matchesName = event.title.toLowerCase().contains(query.toLowerCase());
      bool matchesDescription = event.description.toLowerCase().contains(query.toLowerCase());

      // Check if the event type matches the query (case-insensitive)
      bool matchesType = event.type.toString().toLowerCase().contains(query.toLowerCase());

      return matchesName || matchesDescription || matchesType;
    }).toList();
  }


  // Control favourite status for an event (similar to ReportsDataStorage)
  void controlFavourite(Event event) {
    final index = _eventList.indexOf(event);
    if (index != -1) {
      // Toggle favourite state
      _eventList[index].isFavourite = !event.isFavourite;
      _callback(); // Refresh view
    }
  }

  List<Event> getEventsForDate(DateTime date) {
    return _eventList.where((event) {
      DateTime eventDateOnly = DateTime(
          event.dateTimeStart.year, event.dateTimeStart.month, event.dateTimeStart.day);
      DateTime inputDateOnly =
      DateTime(date.year, date.month, date.day);
      return eventDateOnly.isAtSameMomentAs(inputDateOnly);
    }).toList();
  }
}
