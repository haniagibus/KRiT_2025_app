import 'package:flutter/material.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/models/event/events_data_storage.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'event_tile.dart';

class CalendarWidget extends StatefulWidget {
  final EventsDataStorage eventsDataStorage;
  final String searchQuery;

  const CalendarWidget({
    super.key,
    required this.eventsDataStorage,
    required this.searchQuery,
  });

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late List<DateTime> _availableDates;
  late List<Event> _eventsForSelectedDate;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _filterEventsByDate(_availableDates[0]);
  }

  void _initializeDates() {
    final now = DateTime.now();
    _availableDates = List.generate(3, (index) => now.add(Duration(days: index))); // Show only 3 days
  }

  void _filterEventsByDate(DateTime selectedDate) {
    final events = widget.eventsDataStorage.eventList
        .where((event) => event.name.toLowerCase().contains(widget.searchQuery.toLowerCase()))
        .toList();

    setState(() {
      _eventsForSelectedDate = events.where((event) {
        return event.date.year == selectedDate.year &&
            event.date.month == selectedDate.month &&
            event.date.day == selectedDate.day;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _availableDates.length,
      child: Column(
        children: [
          // Tabs for dates
          Container(
            color: AppColors.background,
            child: TabBar(
              indicatorColor: AppColors.accent,
              indicatorWeight: 4.0,
              labelPadding: EdgeInsets.symmetric(vertical: 8.0),
              tabs: _availableDates.map((date) {
                return Tab(
                  child: Text(
                    "${date.day}/${date.month}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
              labelColor: AppColors.accent,
              unselectedLabelColor: AppColors.textSecondary,
              onTap: (index) {
                _filterEventsByDate(_availableDates[index]);
              },
            ),
          ),
          // Events list for the selected tab's date
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: _availableDates.map((date) {
                final eventsForDay = _eventsForSelectedDate.where((event) {
                  return event.date.year == date.year &&
                      event.date.month == date.month &&
                      event.date.day == date.day;
                }).toList();

                return ListView(
                  children: eventsForDay
                      .map(
                        (event) => EventTile(
                      event,
                      onFavouriteControl: () {
                        setState(() {
                          widget.eventsDataStorage.controlFavourite(event);
                        });
                      },
                    ),
                  )
                      .toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
