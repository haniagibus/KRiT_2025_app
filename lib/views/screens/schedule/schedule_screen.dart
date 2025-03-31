import 'package:flutter/material.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/models/event/events_data_storage.dart';
import 'package:krit_app/views/widgets/searchbar_widget.dart';
import '../../widgets/schedule/calendar_widget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EventViewState();
}

class _EventViewState extends State<ScheduleScreen> {
  late final EventsDataStorage _eventsDataStorage;
  String _searchQuery = '';

  // @override
  // void initState() {
  //   _eventsDataStorage = EventsDataStorage(() => setState(() {}));
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
    _eventsDataStorage = EventsDataStorage(() => setState(() {}));
    _loadEvents(); // Pobierz eventy
  }

  Future<void> _loadEvents() async {
    await _eventsDataStorage.initializeEvents();
  }


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
