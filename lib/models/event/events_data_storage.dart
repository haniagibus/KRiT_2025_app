import 'dart:collection';
import 'dart:math';
import 'package:krit_app/config.dart';

import 'event.dart';

class EventsDataStorage {
  static final EventsDataStorage _singleton = EventsDataStorage._internal();

  List<Event> _eventList = [];
  List<Event> get eventList => UnmodifiableListView(_eventList);
  late Function _callback;
  List<Event> get favoriteEvents => _eventList.where((event) => event.isFavourite).toList();

  factory EventsDataStorage(Function callback) {
    _singleton._callback = callback;
    return _singleton;
  }

  final random = Random();

  String randomTitle() {
    return titles[random.nextInt(titles.length)];
  }

  DateTime randomDate() {
    return dates[random.nextInt(dates.length)];
  }
  final titles = ["Food Carnival", "Coding Bootcamp", "Movie Night", "Yoga Session"];

  final dates = [
    DateTime(2025, 1, 19),
    DateTime(2025, 1, 20),
    DateTime(2025, 1, 21),
  ];

  EventsDataStorage._internal() {
    if (Config.useMockData) {
      for (int i = 0; i < 10; i++) {
        MockEvent mockEvent = new MockEvent(i, randomTitle(),randomDate());
        mockEvent.name = mockEvent.name + i.toString();
        _eventList.add(mockEvent);
      }
    }
    // else {
    //   updateData();
    // }
  }

  List<Event> getEventsForDate(DateTime date) {
    return _eventList.where((event) {
      DateTime eventDateOnly = DateTime(event.date.year, event.date.month, event.date.day);
      DateTime inputDateOnly = DateTime(date.year, date.month, date.day);
      return eventDateOnly.isAtSameMomentAs(inputDateOnly);
    }).toList();
  }

  void controlFavourite(Event event) {
    final index = _eventList.indexOf(event);
    if (index != -1) {
      _eventList[index].isFavourite = !event.isFavourite;
      _callback(); // Odświeżenie widoku
    }
  }

  // Future<void> updateData() async {
  //   if (Config.useMockData) return;
  //   // TODO: Check the status and give information to the user if it failed
  //   var response = await Requests().get(Config.apiUrl + 'partners');
  //   final json = response.data;
  //
  //   _eventList.clear();
  //   for (var json in json) {
  //     json["cover"] = await Requests().resolveRedirect(json["cover"]);
  //     json["logo"] = await Requests().resolveRedirect(json["logo"]);
  //     _eventList.add(Event.fromJson(json));
  //   }
  //   _callback();
  // }
}