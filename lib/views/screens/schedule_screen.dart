import 'package:flutter/material.dart';
import 'package:krit_app/models/event.dart';
import 'package:krit_app/models/events_data_storage.dart';
import 'package:krit_app/views/widgets/event_tile.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EventViewState();
}

class _EventViewState extends State<ScheduleScreen> {
  late final EventsDataStorage _eventsDataStorage;

  @override
  void initState() {
    _eventsDataStorage = EventsDataStorage(_refresh);
    super.initState();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: _createWidgets(_eventsDataStorage.eventList));
  }

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
}