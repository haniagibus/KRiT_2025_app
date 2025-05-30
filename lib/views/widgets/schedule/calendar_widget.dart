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

class _CalendarWidgetState extends State<CalendarWidget> with SingleTickerProviderStateMixin {
  List<DateTime> _availableDates = [];
  List<Event> _eventsForSelectedDate = [];
  late DateTime _selectedDate;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataStorage = context.read<EventsDataStorage>();
      await dataStorage.refreshEvents();

      _initializeDates();

      if (_availableDates.isNotEmpty) {
        _selectedDate = _availableDates[0];
        _tabController = TabController(length: _availableDates.length, vsync: this);
        _tabController!.addListener(() {
          if (_tabController!.indexIsChanging) {
            setState(() {
              _selectedDate = _availableDates[_tabController!.index];
              _filterEventsByDate();
            });
          }
        });
      } else {
        _tabController = TabController(length: 1, vsync: this);
        _selectedDate = DateTime.now();
      }

      _filterEventsByDate();

      setState(() {});
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
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsDataStorage = context.watch<EventsDataStorage>();

    if (_availableDates.isEmpty || _tabController == null) {
      return Center(child: Text("Brak dostępnych dat"));
    }

    return Column(
      children: [
        Container(
          color: AppColors.background,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.accent,
            indicatorWeight: 4.0,
            labelPadding: const EdgeInsets.symmetric(vertical: 8.0),
            tabs: _availableDates.map((date) {
              return Tab(
                child: Text(
                  "${date.day}/${date.month}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.text_secondary,
          ),
        ),
        Expanded(
          child: _eventsForSelectedDate.isEmpty
              ? const Center(child: Text("Brak wyników"))
              : ListView(
            children: _eventsForSelectedDate
                .map(
                  (event) => EventTile(
                event,
                onFavouriteControl: (updatedEvent) async {
                  await eventsDataStorage.controlFavourite(updatedEvent);
                  setState(() {
                  });
                },
              ),
            )
                .toList(),
          ),
        ),
      ],
    );
  }
}
