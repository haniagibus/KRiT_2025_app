import 'package:flutter/material.dart';
import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/models/event/events_data_storage.dart';
import '../../widgets/schedule/event_tile.dart';

class EventManagerScreen extends StatefulWidget {
  final EventsDataStorage eventsDataStorage;

  const EventManagerScreen({super.key, required this.eventsDataStorage});

  @override
  _EventManagerScreenState createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  late List<Event> _events;

  @override
  void initState() {
    super.initState();
    _events = widget.eventsDataStorage.eventList; // Poprawione pobieranie danych
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista Wydarzeń")),
      body: _events.isEmpty
          ? const Center(child: Text("Brak wydarzeń"))
          : ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          return EventTile(
            _events[index],
            onFavouriteControl: () {
              // Tutaj możesz dodać funkcję do obsługi ulubionych
            },
          );
        },
      ),
    );
  }
}
