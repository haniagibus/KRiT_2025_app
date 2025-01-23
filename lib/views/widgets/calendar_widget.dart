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
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _selectedDate = _availableDates[0];
    _filterEventsByDate();
  }

  void _initializeDates() {
    final now = DateTime.now();
    _availableDates = List.generate(3, (index) => now.add(Duration(days: index)));
  }

  void _filterEventsByDate() {
    final events = widget.eventsDataStorage.eventList
        .where((event) => event.name.toLowerCase().contains(widget.searchQuery.toLowerCase()))
        .toList();

    setState(() {
      _eventsForSelectedDate = events.where((event) {
        return event.dateTimeStart.year == _selectedDate.year &&
            event.dateTimeStart.month == _selectedDate.month &&
            event.dateTimeStart.day == _selectedDate.day;
      }).toList();
    });
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _filterEventsByDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _availableDates.length,
      child: Column(
        children: [
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
                setState(() {
                  _selectedDate = _availableDates[index];
                  _filterEventsByDate();
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: _eventsForSelectedDate
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
            ),
          ),
        ],
      ),
    );
  }
}
