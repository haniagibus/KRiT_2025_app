import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/models/event/events_data_storage.dart';
import 'package:krit_app/theme/app_colors.dart';
import 'event_tile.dart';

class CalendarWidget extends StatefulWidget {
  final String searchQuery;

  const CalendarWidget({
    super.key,
    required this.searchQuery,
  });

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late List<DateTime> _availableDates;
  List<Event> _eventsForSelectedDate = [];
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataStorage = context.read<EventsDataStorage>();
      await dataStorage.refreshEvents();

      setState(() {
        _initializeDates();
        if (_availableDates.isNotEmpty) {
          _selectedDate = _availableDates[0];
        }
        _filterEventsByDate();
      });
    });
  }

  void _initializeDates() {
    final events = context.read<EventsDataStorage>().eventList;
    _availableDates = events
        .map((event) => DateTime(event.dateTimeStart.year,
            event.dateTimeStart.month, event.dateTimeStart.day))
        .toSet()
        .toList();
    _availableDates.sort((a, b) => a.compareTo(b));
  }

  void _filterEventsByDate() {
    final dataStorage = context.read<EventsDataStorage>();
    final events = dataStorage.filterEventsByQuery(widget.searchQuery);

    final filteredByDate = events.where((event) {
      return event.dateTimeStart.year == _selectedDate.year &&
          event.dateTimeStart.month == _selectedDate.month &&
          event.dateTimeStart.day == _selectedDate.day;
    }).toList();

    setState(() {
      _eventsForSelectedDate = filteredByDate;
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
    final eventsDataStorage = context.watch<EventsDataStorage>();

    _initializeDates();

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
              unselectedLabelColor: AppColors.text_secondary,
              onTap: (index) {
                setState(() {
                  _selectedDate = _availableDates[index];
                  _filterEventsByDate();
                });
              },
            ),
          ),
          Expanded(
            child: _eventsForSelectedDate.isEmpty
                ? Center(child: Text("Brak wydarzeń na ten dzień"))
                : ListView(
                    children: _eventsForSelectedDate
                        .map(
                          (event) => EventTile(
                            event,
                            onFavouriteControl: (updatedEvent) async {
                              await eventsDataStorage
                                  .controlFavourite(updatedEvent);
                              setState(() {});
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
