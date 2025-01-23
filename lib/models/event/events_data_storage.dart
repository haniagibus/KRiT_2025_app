import 'dart:collection';
import 'dart:math';
import 'package:krit_app/config.dart';
import 'event.dart';
import 'event_type.dart';

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

  final random = Random();

  // Mock data helpers
  String randomTitle() {
    return titles[random.nextInt(titles.length)];
  }

  DateTime randomDate() {
    return dates[random.nextInt(dates.length)];
  }

  String randomBuilding() {
    return buildings[random.nextInt(buildings.length)];
  }

  String randomRoom() {
    return rooms[random.nextInt(rooms.length)];
  }

  String randomDescription() {
    return descriptions[random.nextInt(descriptions.length)];
  }

  EventType randomEventType() {
    return EventType.values[random.nextInt(EventType.values.length)];
  }

  final titles = [
    "Food Carnival",
    "Coding Bootcamp",
    "Movie Night",
    "Yoga Session"
  ];

  final dates = [
    DateTime(2025, 1, 23, 10, 0),
    DateTime(2025, 1, 24, 14, 30),
    DateTime(2025, 1, 25, 18, 0),
  ];

  final buildings = ["Main Hall", "Tech Building", "Library", "Gymnasium"];
  final rooms = ["Room 101", "Room 202", "Auditorium", "Room 303"];
  final descriptions = [
    "A fun-filled event for everyone!",
    "Learn to code like a pro.",
    "Enjoy a relaxing evening with a classic movie.",
    "Stretch and relax with a guided yoga session."
  ];

  EventsDataStorage._internal() {
    if (Config.useMockData) {
      for (int i = 0; i < 10; i++) {
        MockEvent mockEvent = MockEvent(
          i,
          randomTitle(),
          randomEventType(),
          randomDate(),
          randomDate().add(Duration(hours: 2)), // Random 2-hour duration
          randomDescription(),
          randomBuilding(),
          randomRoom(),
          [],
        );
        mockEvent.name += " $i";
        _eventList.add(mockEvent);
      }
    }
    // else {
    //   updateData();
    // }
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

  void controlFavourite(Event event) {
    final index = _eventList.indexOf(event);
    if (index != -1) {
      // Toggle favourite state
      _eventList[index].isFavourite = !event.isFavourite;
      _callback(); // Refresh view
    }
  }

// Uncomment and implement when fetching real data
// Future<void> updateData() async {
//   if (Config.useMockData) return;
//   var response = await Requests().get(Config.apiUrl + 'events');
//   final json = response.data;

//   _eventList.clear();
//   for (var json in json) {
//     _eventList.add(Event.fromJson(json));
//   }
//   _callback();
// }
}
