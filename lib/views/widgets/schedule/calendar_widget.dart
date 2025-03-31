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
  List<Event> _eventsForSelectedDate = []; // 🛠 Inicjalizujemy pustą listę
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _selectedDate = _availableDates[0];

    // ⏳ Poczekaj, aż widget się załaduje, a potem przefiltruj eventy
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _filterEventsByDate();
    });
  }

  void _initializeDates() {
    final start = DateTime(2024, 9, 11);
    _availableDates = List.generate(3, (index) => start.add(Duration(days: index)));
  }

  void _filterEventsByDate() {
    final events = widget.eventsDataStorage.eventList;

    print("📢 Liczba eventów: ${events.length}"); // 🔍 Debugging

    final filteredEvents = events.where((event) {
      bool matchesSearch = event.title.toLowerCase().contains(widget.searchQuery.toLowerCase());

      bool matchesReport = event.reports.any((report) {
        return report.title.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
            report.author.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
            report.keywords.any((keyword) => keyword.toLowerCase().contains(widget.searchQuery.toLowerCase()));
      });

      return matchesSearch || matchesReport;
    }).toList();

    setState(() {
      _eventsForSelectedDate = filteredEvents.where((event) {
        return event.dateTimeStart.year == _selectedDate.year &&
            event.dateTimeStart.month == _selectedDate.month &&
            event.dateTimeStart.day == _selectedDate.day;
      }).toList();

      print("📆 Eventy na ${_selectedDate}: ${_eventsForSelectedDate.length}"); // 🔍 Debugging
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
