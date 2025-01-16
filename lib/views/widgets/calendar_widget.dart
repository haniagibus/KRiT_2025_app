import 'package:flutter/material.dart';
import 'package:krit_app/models/event.dart';
import 'package:krit_app/models/events_data_storage.dart';

import 'event_tile.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late final EventsDataStorage _eventsDataStorage;
  DateTime _selectedDate = DateTime.now();
  List<Event> _eventsForSelectedDate = [];

  @override
  void initState() {
    super.initState();
    _eventsDataStorage = EventsDataStorage(_refresh); // Initialize event data storage
    _eventsForSelectedDate = _eventsDataStorage.getEventsForDate(_selectedDate); // Show all events initially
  }

  void _refresh() {
    setState(() {
      _eventsForSelectedDate = _eventsDataStorage.getEventsForDate(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileWidth = screenWidth / 3;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7, // Display 7 days (a week)
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected = date.day == _selectedDate.day &&
                    date.month == _selectedDate.month &&
                    date.year == _selectedDate.year;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                      _eventsForSelectedDate = _eventsDataStorage.getEventsForDate(_selectedDate); // Aktualizacja na podstawie nowego _selectedDate
                    });
                  },
                  child: Container(
                    width: tileWidth,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${date.day}" ".""${date.month}",
                          style: TextStyle(
                            fontSize: 20,
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Event list for the selected date
          Expanded(
            child: ListView(
              children: _createWidgets(_eventsForSelectedDate),
            ),
          ),
        ],
      ),
    );
  }
}

//tego tu nie powinno chyba, przekazywac kalendarzowi liste wyszukanych eventów? on segregowałby je po dacie?
//nie wiem ://
List<EventTile> _createWidgets(List<Event>? partners) {
  if (partners == null || !partners.isNotEmpty) {
    return [];
  }
  List<EventTile> list = [];
  for (var partnerData in partners) {
    list.add(EventTile(partnerData));
  }
  return list;
}