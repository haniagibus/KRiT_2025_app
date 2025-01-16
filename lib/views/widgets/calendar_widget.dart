import 'package:flutter/material.dart';
import 'package:krit_app/models/event.dart';

import 'event_tile.dart';

class CalendarWidget extends StatefulWidget {
  final List<Event> events;
  const CalendarWidget({super.key, required this.events});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now();
  late List<Event> _eventsForSelectedDate;

  @override
  void initState() {
    super.initState();
    _filterEventsByDate();
  }

  @override
  void didUpdateWidget(covariant CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _filterEventsByDate();
  }

  void _filterEventsByDate() {
    setState(() {
      _eventsForSelectedDate = widget.events
          .where((event) =>
      event.date.year == _selectedDate.year &&
          event.date.month == _selectedDate.month &&
          event.date.day == _selectedDate.day)
          .toList();
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
            height: 50,
            child: Row(
              children: List.generate(
                3,
                    (index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final isSelected = date.day == _selectedDate.day &&
                      date.month == _selectedDate.month &&
                      date.year == _selectedDate.year;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                          _filterEventsByDate();
                        });
                      },
                      child: Container(
                        //margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        //padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[300],
                          //borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${date.day}/${date.month}",
                              style: TextStyle(
                                fontSize: 15,
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Event list for the selected date
          Expanded(
            child: ListView(
              children: _eventsForSelectedDate
                  .map((event) => EventTile(event))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
