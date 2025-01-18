import 'package:flutter/material.dart';
import 'package:krit_app/models/event.dart';
import 'package:krit_app/models/events_data_storage.dart';
import 'package:krit_app/views/widgets/searchbar_widget.dart';
import '../widgets/calendar_widget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EventViewState();
}

class _EventViewState extends State<ScheduleScreen> {
  late final EventsDataStorage _eventsDataStorage;
  String _searchQuery = '';
  List<Event>? _filteredEvents;

  @override
  void initState() {
    _eventsDataStorage = EventsDataStorage(_refresh);
    _filteredEvents = _eventsDataStorage.eventList;
    super.initState();
  }

  void _refresh() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarApp(
          onChanged: (String value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CalendarWidget(
              eventsDataStorage: _eventsDataStorage,
              searchQuery: _searchQuery,
            ),
          ),
        ),
      ],
    );
  }
}