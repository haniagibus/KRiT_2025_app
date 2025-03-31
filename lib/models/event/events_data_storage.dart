import 'dart:collection';
import 'package:krit_app/config.dart';
import 'package:krit_app/models/ApiService.dart';
import '../report/report.dart';
import '../report/reports_data_storage.dart';
import 'event.dart';
import 'mocked_events.dart';

class EventsDataStorage {
  static final EventsDataStorage _singleton = EventsDataStorage._internal();

  List<Event> _eventList = [];
  List<Event> get eventList => UnmodifiableListView(_eventList);
  late Function _callback;

  final ReportsDataStorage _reportsStorage = ReportsDataStorage(() {});

  List<Event> get favoriteEvents =>
      _eventList.where((event) => event.isFavourite).toList();

  factory EventsDataStorage(Function callback) {
    _singleton._callback = callback;
    return _singleton;
  }

  // EventsDataStorage._internal() {
  //   if (Config.useMockData) {
  //     _eventList = MockedEvents.getMockedEvents();
  //     // Tworzymy raporty dla eventów
  //     _reportsStorage.generateMockReports(_eventList);
  //   }
  // }




  EventsDataStorage._internal(){}
  //asynchronicznie pobieranie danych
  Future<void> initializeEvents() async {
    print("🟡 Start pobierania eventów");

   // if (!Config.useMockData) {  // Upewnij się, że nie korzystasz z mockowanych danych
      _eventList = await ApiService().fetchEvents();
      print("✅ Pobranie zakończone, liczba eventów: ${_eventList.length}");

      for (var event in _eventList) {
        print("📅 Event w storage: ${event.title} - ${event.dateTimeStart}");
      }

      _callback();
    //}
  }



  List<Event> filterEvents(String query) {
    return _eventList.where((event) {
      bool matchesName = event.title.toLowerCase().contains(query.toLowerCase());
      bool matchesDescription = event.description.toLowerCase().contains(query.toLowerCase());
      bool matchesType = event.type.toString().toLowerCase().contains(query.toLowerCase());
      return matchesName || matchesDescription || matchesType;
    }).toList();
  }

  void controlFavourite(Event event) {
    final index = _eventList.indexOf(event);
    if (index != -1) {
      _eventList[index].isFavourite = !_eventList[index].isFavourite;
      _callback();
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
}
