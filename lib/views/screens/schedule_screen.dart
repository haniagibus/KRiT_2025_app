import 'package:flutter/material.dart';
import 'package:krit_app/models/event.dart';
import 'package:krit_app/models/events_data_storage.dart';
import 'package:krit_app/views/widgets/event_tile.dart';
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

  void _filterEvents() {
    final query = _searchQuery.toLowerCase();
    if (query.isEmpty) {
      _filteredEvents = _eventsDataStorage.eventList;
    } else {
      _filteredEvents = _eventsDataStorage.eventList
          .where((event) => event.name.toLowerCase().contains(query))
          .toList();
    }
  }

  void _refresh() {
    setState(() {
      _filterEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarApp(
          onChanged: (String value) {
            setState(() {
              _searchQuery = value;
              _filterEvents();
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Current Query: $_searchQuery',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        // Expanded(
        //   child: ListView(
        //     children: _createWidgets(_filteredEvents),
        //   ),
        // ),
        Flexible(
          child: CalendarWidget(
            events: _filteredEvents ?? [],
          ),
        ),
      ],
    );
  }

  // List<EventTile> _createWidgets(List<Event>? partners) {
  //   if (partners == null || !partners.isNotEmpty) {
  //     return [];
  //   }
  //   List<EventTile> list = [];
  //   for (var partnerData in partners) {
  //     list.add(EventTile(partnerData));
  //   }
  //   return list;
  // }
}